package com.vbt.AuthenticationSystem.infrastructure.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.vbt.AuthenticationSystem.infrastructure.exception.ApiErrorResponse;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import java.io.IOException;
import java.time.Instant;

@Component
public class ErrorResponseWriter {

    private final ObjectMapper objectMapper;

    public ErrorResponseWriter(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public void write(HttpServletResponse response, int status, String title, String detail, String path) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        ApiErrorResponse errorResponse = new ApiErrorResponse(title, status, detail, path, Instant.now(), null);
        response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
    }
}
