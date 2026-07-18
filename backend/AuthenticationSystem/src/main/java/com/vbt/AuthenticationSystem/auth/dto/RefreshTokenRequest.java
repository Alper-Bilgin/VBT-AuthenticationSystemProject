package com.vbt.AuthenticationSystem.auth.dto;

import jakarta.validation.constraints.NotBlank;

public record RefreshTokenRequest(
        @NotBlank(message = "Refresh token boş olamaz.")
        String refreshToken
) {
}
