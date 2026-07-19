package com.vbt.AuthenticationSystem.auth.service;
import org.springframework.transaction.annotation.Transactional;
import com.vbt.AuthenticationSystem.auth.dto.LoginRequest;
import com.vbt.AuthenticationSystem.auth.dto.RegisterRequest;
import com.vbt.AuthenticationSystem.auth.dto.TokenResponse;
import com.vbt.AuthenticationSystem.auth.model.RefreshToken;
import com.vbt.AuthenticationSystem.infrastructure.exception.EmailAlreadyExistsException;
import com.vbt.AuthenticationSystem.infrastructure.exception.TokenException;
import com.vbt.AuthenticationSystem.user.dto.UserResponse;
import com.vbt.AuthenticationSystem.user.entity.Role;
import com.vbt.AuthenticationSystem.user.entity.User;
import com.vbt.AuthenticationSystem.user.repository.UserRepository;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthenticationService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final RefreshTokenService refreshTokenService;

    public AuthenticationService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService, AuthenticationManager authenticationManager, RefreshTokenService refreshTokenService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
        this.refreshTokenService = refreshTokenService;
    }

    @Transactional
    public void register(RegisterRequest request) {
        if (userRepository.findByEmail(request.email()).isPresent()) {
            throw new EmailAlreadyExistsException("Bu e-posta adresi zaten kullanımda.");
        }

        User user = User.builder()
                .email(request.email())
                .passwordHash(passwordEncoder.encode(request.password())) // Alan adı düzeltildi
                .role(Role.USER) // Not-null constraint hatasını önlemek için varsayılan rol
                .build();

        userRepository.save(user);
    }

    @Transactional
    public TokenResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );

        User user = userRepository.findByEmail(request.email()).orElseThrow();

        String accessToken = jwtService.generateToken(user);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user.getId());

        // Eksik parametreler eklendi
        UserResponse userResponse = new UserResponse(
                user.getId(),
                user.getEmail(),
                user.getRole(),
                user.getCreatedAt()
        );

        return new TokenResponse(
                accessToken,
                refreshToken.getRawToken(),
                "Bearer",
                jwtService.getJwtExpiration(),
                userResponse
        );
    }

    @Transactional
    public TokenResponse refreshToken(String incomingToken) {
        return refreshTokenService.findByToken(incomingToken)
                .map(refreshTokenService::verifyExpiration)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String accessToken = jwtService.generateToken(user);
                    return new TokenResponse(accessToken, incomingToken, "Bearer", jwtService.getJwtExpiration(), null);
                })
                .orElseThrow(() -> new TokenException("Refresh token geçersiz veya bulunamadı."));
    }

    public void logout(String incomingToken) {
        refreshTokenService.findByToken(incomingToken).ifPresent(refreshTokenService::revokeToken);
    }
}
