package com.vbt.AuthenticationSystem.infrastructure.security;

import com.vbt.AuthenticationSystem.infrastructure.utils.ErrorResponseWriter;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.BucketConfiguration;
import io.github.bucket4j.distributed.proxy.ProxyManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.nio.charset.StandardCharsets;
import java.time.Duration;

@Component
public class RateLimitInterceptor implements HandlerInterceptor{

    private final ProxyManager<String> proxyManager;
    private final ErrorResponseWriter errorResponseWriter;

    // Varsayılan olarak true (aktif), properties'den ezilebilir.
    @Value("${app.security.rate-limit.enabled:true}")
    private boolean rateLimitEnabled;

    public RateLimitInterceptor(ProxyManager<String> proxyManager, ErrorResponseWriter errorResponseWriter) {
        this.proxyManager = proxyManager;
        this.errorResponseWriter = errorResponseWriter;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // Eğer rate limiting kapalıysa (örneğin test ortamı), direkt devam et
        if (!rateLimitEnabled) {
            return true;
        }

        String clientIp = getClientIp(request);
        String path = request.getRequestURI();

        String key = "rate_limit:" + path + ":" + clientIp;
        Bucket bucket = proxyManager.builder().build(key, () -> getConfigurationForPath(path));

        if (bucket.tryConsume(1)) {
            return true;
        } else {
            errorResponseWriter.write(
                    response,
                    HttpStatus.TOO_MANY_REQUESTS.value(),
                    "Çok Fazla İstek",
                    "Kısa sürede çok fazla deneme yaptınız. Lütfen 1 dakika sonra tekrar deneyin.",
                    path
            );
            return false;
        }
    }

    private BucketConfiguration getConfigurationForPath(String path) {
        int capacity = path.contains("/register") ? 3 : 5; // Register için 3, Login için 5 hak
        return BucketConfiguration.builder()
                .addLimit(Bandwidth.builder()
                        .capacity(capacity)
                        .refillGreedy(capacity, Duration.ofMinutes(1)) // 1 dakikada tamamen dolar
                        .build())
                .build();
    }

    private String getClientIp(HttpServletRequest request) {
        // Reverse proxy (Nginx vb.) arkasındaysa gerçek IP'yi almak için X-Forwarded-For kontrolü
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }
}
