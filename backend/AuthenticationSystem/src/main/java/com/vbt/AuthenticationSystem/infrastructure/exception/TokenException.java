package com.vbt.AuthenticationSystem.infrastructure.exception;

// Süresi dolmuş veya iptal edilmiş token hatalarını tek çatı altında (401 Unauthorized) yakalamak için
public class TokenException extends RuntimeException {
    public TokenException(String message) {
        super(message);
    }
}
