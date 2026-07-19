package com.vbt.AuthenticationSystem.infrastructure.exception;
import org.springframework.security.access.AccessDeniedException;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import io.jsonwebtoken.security.SignatureException;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    // 1. Form Validasyon Hataları (DTO'lardaki @NotBlank, @Size vb. 400 Bad Request)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidationExceptions(
            MethodArgumentNotValidException ex,
            HttpServletRequest request
    ) {
        Map<String, String> errors = new HashMap<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }

        ApiErrorResponse response = new ApiErrorResponse(
                "Geçersiz İstek Parametreleri",
                HttpStatus.BAD_REQUEST.value(),
                "Gönderilen verilerde doğrulama hataları mevcut.",
                request.getRequestURI(),
                Instant.now(),
                errors
        );

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    // 2. Kendi Yazdığımız Token Hataları (401 Unauthorized)
    @ExceptionHandler(TokenException.class)
    public ResponseEntity<ApiErrorResponse> handleTokenException(
            TokenException ex,
            HttpServletRequest request
    ) {
        return buildResponse(
                "Yetkilendirme Hatası",
                HttpStatus.UNAUTHORIZED,
                ex.getMessage(),
                request.getRequestURI()
        );
    }

    // 3. JWT Kütüphanesinin (jjwt) Fırlattığı Hatalar (Filtreden handlerExceptionResolver ile gelenler - 401)
    @ExceptionHandler({
            ExpiredJwtException.class,
            SignatureException.class,
            MalformedJwtException.class,
            UnsupportedJwtException.class // Eklendi
    })
    public ResponseEntity<ApiErrorResponse> handleJwtExceptions(Exception ex, HttpServletRequest request) {
        String detailMessage = ex instanceof ExpiredJwtException
                ? "Access token süresi dolmuş."
                : "Geçersiz, desteklenmeyen veya bozuk token.";
        return buildResponse("Geçersiz Token", HttpStatus.UNAUTHORIZED, detailMessage, request.getRequestURI());
    }

    // 4. Spring Security Login Hataları (Yanlış Şifre/Email - 401 Unauthorized)
    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiErrorResponse> handleBadCredentials(
            BadCredentialsException ex,
            HttpServletRequest request
    ) {
        return buildResponse(
                "Giriş Başarısız",
                HttpStatus.UNAUTHORIZED,
                "E-posta adresi veya şifre hatalı.",
                request.getRequestURI()
        );
    }

    // 5. Kullanıcı Bulunamadı (404 Not Found)
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ApiErrorResponse> handleUserNotFound(
            UserNotFoundException ex,
            HttpServletRequest request
    ) {
        return buildResponse(
                "Kayıt Bulunamadı",
                HttpStatus.NOT_FOUND,
                ex.getMessage(),
                request.getRequestURI()
        );
    }

    // 6. Beklenmeyen Sunucu Hataları (500 Internal Server Error)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleAllOtherExceptions(Exception ex, HttpServletRequest request) {
        log.error("Beklenmeyen sunucu hatası | Path: {} | Mesaj: {}", request.getRequestURI(), ex.getMessage(), ex);
        return buildResponse(
                "Sunucu Hatası",
                HttpStatus.INTERNAL_SERVER_ERROR,
                "İşlem sırasında beklenmeyen bir hata oluştu.",
                request.getRequestURI()
        );
    }

    // 7. E-posta zaten kullanımda (409 Conflict)
    @ExceptionHandler(EmailAlreadyExistsException.class)
    public ResponseEntity<ApiErrorResponse> handleEmailExists(EmailAlreadyExistsException ex, HttpServletRequest request) {
        return buildResponse("Kayıt Hatası", HttpStatus.CONFLICT, ex.getMessage(), request.getRequestURI());
    }

    // 8. Hesap askıya alınmış / deaktive edilmiş (403 Forbidden)
    @ExceptionHandler(DisabledException.class)
    public ResponseEntity<ApiErrorResponse> handleDisabledAccount(DisabledException ex, HttpServletRequest request) {
        return buildResponse("Hesap Askıya Alınmış", HttpStatus.FORBIDDEN, "Bu hesap devre dışı bırakılmış.", request.getRequestURI());
    }

    // Yardımcı Metot: Kod tekrarını önlemek için
    private ResponseEntity<ApiErrorResponse> buildResponse(
            String title,
            HttpStatus status,
            String detail,
            String instance
    ) {
        ApiErrorResponse response = new ApiErrorResponse(
                title,
                status.value(),
                detail,
                instance,
                Instant.now(),
                null // Validasyon hatası olmayan durumlarda invalidParams null kalır ve JSON'a yazılmaz
        );
        return ResponseEntity.status(status).body(response);
    }

    //  Bozuk JSON Body (400)
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiErrorResponse> handleMalformedJson(HttpMessageNotReadableException ex, HttpServletRequest request) {
        return buildResponse("Geçersiz İstek", HttpStatus.BAD_REQUEST, "Gönderilen veri formatı (JSON) hatalı.", request.getRequestURI());
    }

    //  Metot Seviyesi Güvenlik Yetki İhlali (403)
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiErrorResponse> handleAccessDenied(AccessDeniedException ex, HttpServletRequest request) {
        return buildResponse("Yetkisiz İşlem", HttpStatus.FORBIDDEN, "Bu işlem için gerekli izniniz bulunmamaktadır.", request.getRequestURI());
    }
}
