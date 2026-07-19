package com.vbt.AuthenticationSystem;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.test.context.ActiveProfiles;
import org.testcontainers.containers.PostgreSQLContainer;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test") // src/test/resources/application-test.yml kullanılmasını sağlar
public abstract class BaseIntegrationTest {

    // Konteyner static tanımlanır, böylece tüm test metotları için 1 kez ayağa kalkar
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>(
            "postgres:16-alpine"
    );

    static {
        postgres.start();
    }
}
