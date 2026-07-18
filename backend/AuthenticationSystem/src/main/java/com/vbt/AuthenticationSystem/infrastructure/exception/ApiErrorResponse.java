package com.vbt.AuthenticationSystem.infrastructure.exception;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.Map;

// Sadece dolu olan (null olmayan) alanlar JSON'a dahil edilsin
@JsonInclude(JsonInclude.Include.NON_NULL)
public record ApiErrorResponse(
        String title,
        int status,
        String detail,
        String instance,
        Instant timestamp,
        Map<String, String> invalidParams // Sadece form validasyon hataları olduğunda dolacak
) {
}
