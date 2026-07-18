package com.vbt.AuthenticationSystem.auth.model;

import com.vbt.AuthenticationSystem.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "refresh_tokens")
public class RefreshToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Gerçek token'ı değil, sadece SHA-256 hash'ini saklıyoruz (64 karakter)
    @Column(nullable = false, unique = true, length = 64)
    private String tokenHash;

    @Column(nullable = false)
    private Instant expiryDate;

    @Builder.Default
    @Column(nullable = false, updatable = false)
    private Instant issuedAt = Instant.now();

    @Builder.Default
    private boolean isRevoked = false;

    @Transient
    private String rawToken;

    // Veritabanı bütünlüğü için nullable = false eklendi
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "id", nullable = false)
    private User user;
}