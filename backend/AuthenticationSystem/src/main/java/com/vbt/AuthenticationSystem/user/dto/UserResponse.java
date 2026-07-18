package com.vbt.AuthenticationSystem.user.dto;

import com.vbt.AuthenticationSystem.user.entity.Role;

import java.time.LocalDateTime;

public record UserResponse(
        Long id,
        String email,
        Role role,
        LocalDateTime createdAt
) {
}
