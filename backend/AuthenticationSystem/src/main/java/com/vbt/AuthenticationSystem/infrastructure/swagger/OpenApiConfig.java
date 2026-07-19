package com.vbt.AuthenticationSystem.infrastructure.swagger;

import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
@Configuration
@SecurityScheme(
        name = "Bearer Authentication",
        type = SecuritySchemeType.HTTP,
        bearerFormat = "JWT",
        scheme = "bearer"
)
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("VBT Authentication API")
                        .version("1.0.0")
                        .description("Spring Boot 3.x ve JWT tabanlı Güvenli Kimlik Doğrulama Sistemi.")
                        .contact(new Contact().name("Backend Takımı").email("iletisim@vbt.com.tr")));

        // .addSecurityItem(...) satırı SİLİNDİ!
    }
}
