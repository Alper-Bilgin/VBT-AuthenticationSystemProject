package com.vbt.AuthenticationSystem.auth.repository;

import com.vbt.AuthenticationSystem.auth.model.RefreshToken;
import com.vbt.AuthenticationSystem.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {

    // Artık plain token değil, hash üzerinden arama yapıyoruz
    Optional<RefreshToken> findByTokenHash(String tokenHash);

    // Kullanıcının tüm oturumlarını kapatmak (Logout / Revoke All) için
    List<RefreshToken> findAllByUserAndIsRevokedFalse(User user);

    // Kullanıcı hesabı silindiğinde çağrılabilecek (Cascade alternatif olarak) veya
    // süresi dolmuş token'ları temizleyen bir cron job için
    void deleteAllByUser(User user);
}
