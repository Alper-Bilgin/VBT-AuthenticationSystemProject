package com.vbt.AuthenticationSystem.infrastructure.config;

import io.github.bucket4j.distributed.proxy.ProxyManager;
import io.github.bucket4j.redis.redisson.cas.RedissonBasedProxyManager;
import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RateLimitConfig {

    // Tip tekrar String olarak güncellendi
    @Bean
    public ProxyManager<String> proxyManager(RedissonClient redissonClient) {
        return RedissonBasedProxyManager.builderFor(
                ((Redisson) redissonClient).getCommandExecutor()
        ).build();
    }
}
