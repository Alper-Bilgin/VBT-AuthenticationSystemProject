package com.vbt.AuthenticationSystem.infrastructure.security;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.vbt.AuthenticationSystem.infrastructure.exception.ApiErrorResponse;
import com.vbt.AuthenticationSystem.infrastructure.utils.ErrorResponseWriter;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.time.Instant;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final AuthenticationProvider authenticationProvider;
    private final ErrorResponseWriter errorResponseWriter;

    public SecurityConfiguration(
            JwtAuthenticationFilter jwtAuthFilter,
            AuthenticationProvider authenticationProvider,
            ErrorResponseWriter errorResponseWriter // ObjectMapper yerine eklendi
    ) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.authenticationProvider = authenticationProvider;
        this.errorResponseWriter = errorResponseWriter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                        // LOGOUT BURAYA EKLENDİ
                        .requestMatchers("/api/v1/auth/register", "/api/v1/auth/login", "/api/v1/auth/refresh", "/api/v1/auth/logout").permitAll()
                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                // JWT Filtresinden önce takılan Spring Security hataları için (401 ve 403)
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) ->
                                errorResponseWriter.write(
                                        response,
                                        HttpServletResponse.SC_UNAUTHORIZED,
                                        "Yetkisiz Erişim",
                                        "Bu kaynağa erişmek için geçerli bir kimlik doğrulaması gerekiyor.",
                                        request.getRequestURI()
                                )
                        )
                        .accessDeniedHandler((request, response, accessDeniedException) ->
                                errorResponseWriter.write(
                                        response,
                                        HttpServletResponse.SC_FORBIDDEN,
                                        "Erişim Reddedildi",
                                        "Bu işlemi gerçekleştirmek için yeterli yetkiniz bulunmuyor.",
                                        request.getRequestURI()
                                )
                        )
                );

        return http.build();
    }
}
