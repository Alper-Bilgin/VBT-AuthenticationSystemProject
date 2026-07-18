package com.vbt.AuthenticationSystem.auth.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.vbt.AuthenticationSystem.user.dto.UserResponse;

@JsonInclude(JsonInclude.Include.NON_NULL) // User null ise JSON'da gözükmeyecek
public record TokenResponse(
        @JsonProperty("access_token")
        String accessToken,

        @JsonProperty("refresh_token")
        String refreshToken,

        @JsonProperty("token_type")
        String tokenType,

        @JsonProperty("expires_in")
        long expiresIn,

        @JsonProperty("user")
        UserResponse user
) {
}
