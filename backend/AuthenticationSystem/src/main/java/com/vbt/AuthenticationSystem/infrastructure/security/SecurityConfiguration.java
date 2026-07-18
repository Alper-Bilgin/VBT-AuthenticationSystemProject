package com.vbt.AuthenticationSystem.infrastructure.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.vbt.AuthenticationSystem.infrastructure.exception.ApiErrorResponse;
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
    private final ObjectMapper objectMapper;

    public SecurityConfiguration(
            JwtAuthenticationFilter jwtAuthFilter,
            AuthenticationProvider authenticationProvider,
            ObjectMapper objectMapper
    ) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.authenticationProvider = authenticationProvider;
        this.objectMapper = objectMapper;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/v1/auth/**").permitAll()
                        // TODO: Swagger eklendiğinde "/v3/api-docs/**", "/swagger-ui/**" eklenecek
                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                // JWT Filtresinden önce takılan Spring Security hataları için (401 ve 403)
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                            response.setContentType("application/json;charset=UTF-8");
                            ApiErrorResponse error = new ApiErrorResponse(
                                    "Yetkisiz Erişim",
                                    HttpServletResponse.SC_UNAUTHORIZED,
                                    "Bu kaynağa erişmek için geçerli bir kimlik doğrulaması gerekiyor.",
                                    request.getRequestURI(),
                                    Instant.now(),
                                    null
                            );
                            response.getWriter().write(objectMapper.writeValueAsString(error));
                        })
                        .accessDeniedHandler((request, response, accessDeniedException) -> {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            response.setContentType("application/json;charset=UTF-8");
                            ApiErrorResponse error = new ApiErrorResponse(
                                    "Erişim Reddedildi",
                                    HttpServletResponse.SC_FORBIDDEN,
                                    "Bu işlemi gerçekleştirmek için yeterli yetkiniz bulunmuyor.",
                                    request.getRequestURI(),
                                    Instant.now(),
                                    null
                            );
                            response.getWriter().write(objectMapper.writeValueAsString(error));
                        })
                );

        return http.build();
    }
}
