package com.vbt.AuthenticationSystem.auth.service;
import com.vbt.AuthenticationSystem.infrastructure.exception.InternalServerException;
import com.vbt.AuthenticationSystem.infrastructure.exception.TokenException;
import com.vbt.AuthenticationSystem.infrastructure.exception.UserNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import com.vbt.AuthenticationSystem.auth.model.RefreshToken;
import com.vbt.AuthenticationSystem.auth.repository.RefreshTokenRepository;
import com.vbt.AuthenticationSystem.user.entity.User;
import com.vbt.AuthenticationSystem.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;
import java.util.Optional;
import java.util.UUID;

@Service
public class RefreshTokenService {

    @Value("${jwt.refresh-token-expiration}")
    private long refreshTokenDurationMs;

    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;

    public RefreshTokenService(RefreshTokenRepository refreshTokenRepository, UserRepository userRepository) {
        this.refreshTokenRepository = refreshTokenRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public RefreshToken createRefreshToken(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("Kullanıcı bulunamadı"));

        // Tek oturum politikası: Yeni giriş yapıldığında eski token'ları iptal et
        revokeAllUserTokens(user);

        // Endüstri standardı 256-bit SecureRandom
        String rawToken = generateSecureToken();
        String tokenHash = hashToken(rawToken);

        RefreshToken refreshToken = RefreshToken.builder()
                .user(user)
                .tokenHash(tokenHash)
                .expiryDate(Instant.now().plusMillis(refreshTokenDurationMs))
                .build();

        refreshToken = refreshTokenRepository.save(refreshToken);
        refreshToken.setRawToken(rawToken);

        return refreshToken;
    }

    @Transactional
    public RefreshToken verifyExpiration(RefreshToken token) {
        if (token.isRevoked()) {
            throw new TokenException("Bu oturum iptal edilmiş. Lütfen tekrar giriş yapın.");
        }

        if (token.getExpiryDate().compareTo(Instant.now()) < 0) {
            refreshTokenRepository.delete(token); // Artık güvenli bir transaction context'i içinde çalışıyor
            throw new TokenException("Oturum süresi dolmuş. Lütfen tekrar giriş yapın.");
        }

        return token;
    }

    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByTokenHash(hashToken(token));
    }

    @Transactional
    public void revokeAllUserTokens(User user) {
        var validTokens = refreshTokenRepository.findAllByUserAndIsRevokedFalse(user);
        if (validTokens.isEmpty()) return;

        validTokens.forEach(token -> token.setRevoked(true));
        refreshTokenRepository.saveAll(validTokens);
    }

    private String generateSecureToken() {
        byte[] randomBytes = new byte[32]; // 256 bit entropi
        new SecureRandom().nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    private String hashToken(String token) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            // GENERIC RUNTİME EXCEPTION YERİNE ÖZEL HATA
            throw new InternalServerException("Hash algoritması başlatılamadı: SHA-256 bulunamadı", e);
        }
    }

    @Transactional
    public void revokeToken(RefreshToken token) {
        token.setRevoked(true);
        refreshTokenRepository.save(token);
    }
}
