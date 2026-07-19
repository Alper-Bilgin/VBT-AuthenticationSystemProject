package com.vbt.AuthenticationSystem.auth.controller;

import com.vbt.AuthenticationSystem.auth.dto.LoginRequest;
import com.vbt.AuthenticationSystem.auth.dto.RefreshTokenRequest;
import com.vbt.AuthenticationSystem.auth.dto.RegisterRequest;
import com.vbt.AuthenticationSystem.auth.dto.TokenResponse;
import com.vbt.AuthenticationSystem.auth.service.AuthenticationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(
        name = "Authentication",
        description = "Kullanıcı kayıt, giriş ve JWT tabanlı oturum yönetimi işlemleri"
)
public class AuthController {

    private final AuthenticationService authenticationService;

    public AuthController(AuthenticationService authenticationService) {
        this.authenticationService = authenticationService;
    }

    @Operation(
            summary = "Kullanıcı Kaydı",
            description = "Sisteme yeni bir kullanıcı kaydeder."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Kullanıcı başarıyla oluşturuldu"),
            @ApiResponse(responseCode = "400", description = "Geçersiz istek veya validasyon hatası"),
            @ApiResponse(responseCode = "409", description = "Bu e-posta adresi zaten kullanımda"),
            @ApiResponse(responseCode = "429", description = "Çok fazla kayıt denemesi (Rate Limit)")
    })
    @PostMapping("/register")
    public ResponseEntity<Void> register(@Valid @RequestBody RegisterRequest request) {
        authenticationService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @Operation(
            summary = "Kullanıcı Girişi",
            description = "Email ve şifre doğrulanır. Başarılı olması durumunda Access Token ve Refresh Token döndürülür."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Giriş başarılı"),
            @ApiResponse(responseCode = "400", description = "Geçersiz istek"),
            @ApiResponse(responseCode = "401", description = "Hatalı email veya şifre"),
            @ApiResponse(responseCode = "429", description = "Çok fazla giriş denemesi (Rate Limit)")
    })
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
        TokenResponse response = authenticationService.login(request);
        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Access Token Yenile",
            description = "Geçerli bir Refresh Token kullanılarak yeni Access Token ve Refresh Token üretilir."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Token başarıyla yenilendi"),
            @ApiResponse(responseCode = "400", description = "Geçersiz istek"),
            @ApiResponse(responseCode = "401", description = "Refresh Token geçersiz veya süresi dolmuş")
    })
    @PostMapping("/refresh")
    public ResponseEntity<TokenResponse> refreshToken(
            @Valid @RequestBody RefreshTokenRequest request) {

        TokenResponse response = authenticationService.refreshToken(request.refreshToken());
        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Oturumu Kapat",
            description = "Refresh Token geçersiz hale getirilerek kullanıcının oturumu sonlandırılır.",
            security = @SecurityRequirement(name = "Bearer Authentication")
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Çıkış işlemi başarılı"),
            @ApiResponse(responseCode = "400", description = "Geçersiz istek"),
            @ApiResponse(responseCode = "401", description = "Yetkisiz erişim")
    })
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(
            @Valid @RequestBody RefreshTokenRequest request) {

        authenticationService.logout(request.refreshToken());
        return ResponseEntity.noContent().build();
    }
}