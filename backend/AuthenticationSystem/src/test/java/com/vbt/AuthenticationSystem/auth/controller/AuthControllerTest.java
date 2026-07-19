package com.vbt.AuthenticationSystem.auth.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.vbt.AuthenticationSystem.BaseIntegrationTest;
import com.vbt.AuthenticationSystem.auth.dto.LoginRequest;
import com.vbt.AuthenticationSystem.auth.dto.RefreshTokenRequest;
import com.vbt.AuthenticationSystem.auth.dto.RegisterRequest;
import com.vbt.AuthenticationSystem.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
@AutoConfigureMockMvc
class AuthControllerTest extends BaseIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    void setUp() {
        // Her testten önce DB'yi temizle ki testler birbirini etkilemesin
        userRepository.deleteAll();
    }

    @Test
    void register_success_returns_201() throws Exception {
        RegisterRequest request = new RegisterRequest("test@example.com", "Password123!");

        mockMvc.perform(post("/api/v1/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());
    }

    @Test
    void register_duplicateEmail_returns_409() throws Exception {
        // İlk kayıt
        RegisterRequest request = new RegisterRequest("duplicate@example.com", "Password123!");
        mockMvc.perform(post("/api/v1/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        // Aynı e-posta ile ikinci kayıt denemesi (GlobalExceptionHandler'ın 409 dönmesini bekliyoruz)
        mockMvc.perform(post("/api/v1/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.title").value("Kayıt Hatası"))
                .andExpect(jsonPath("$.status").value(409));
    }



    @Test
    void login_badCredentials_returns_401() throws Exception {
        LoginRequest loginRequest = new LoginRequest("wrong@example.com", "WrongPassword123!");

        // GlobalExceptionHandler'daki BadCredentialsException yakalayıcısını test ediyoruz
        mockMvc.perform(post("/api/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.title").value("Giriş Başarısız"))
                .andExpect(jsonPath("$.status").value(401));
    }

    // Token almak için yardımcı metot
    private String getValidRefreshToken(String email) throws Exception {
        RegisterRequest registerRequest = new RegisterRequest(email, "Password123!");
        mockMvc.perform(post("/api/v1/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(registerRequest)))
                .andExpect(status().isCreated()); // EKLENDİ: Sessizce patlamayı önler

        LoginRequest loginRequest = new LoginRequest(email, "Password123!");
        String responseBody = mockMvc.perform(post("/api/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(responseBody).path("refresh_token").asText();
    }

    @Test
    void refreshToken_validToken_returnsNewAccessToken() throws Exception {
        String refreshToken = getValidRefreshToken("refresh@example.com");

        RefreshTokenRequest refreshRequest = new RefreshTokenRequest(refreshToken);

        mockMvc.perform(post("/api/v1/auth/refresh")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(refreshRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.access_token").exists())
                .andExpect(jsonPath("$.refresh_token").value(refreshToken)); // Aynı refresh token geri dönmeli
    }

    @Test
    void login_success_returns_tokenAndUser() throws Exception {
        RegisterRequest registerRequest = new RegisterRequest("login@example.com", "Password123!");
        mockMvc.perform(post("/api/v1/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(registerRequest)))
                .andExpect(status().isCreated());

        LoginRequest loginRequest = new LoginRequest("login@example.com", "Password123!");
        mockMvc.perform(post("/api/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.access_token").exists())
                .andExpect(jsonPath("$.refresh_token").exists())
                .andExpect(jsonPath("$.user.email").value("login@example.com"))
                .andExpect(jsonPath("$.user.role").value("USER")); // EKLENDİ: Role kontrolü
    }

    @Test
    void refreshToken_invalidToken_returns401() throws Exception {
        RefreshTokenRequest refreshRequest = new RefreshTokenRequest("gecersiz-token");

        mockMvc.perform(post("/api/v1/auth/refresh")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(refreshRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.title").value("Oturum Hatası")) // GÜNCELLENDİ
                .andExpect(jsonPath("$.status").value(401));
    }

    @Test
    void logout_validToken_returns204AndRevokesToken() throws Exception {
        String refreshToken = getValidRefreshToken("logout@example.com");
        RefreshTokenRequest request = new RefreshTokenRequest(refreshToken);

        mockMvc.perform(post("/api/v1/auth/logout")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isNoContent());

        mockMvc.perform(post("/api/v1/auth/refresh")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.title").value("Oturum Hatası")); // GÜNCELLENDİ
    }
}
