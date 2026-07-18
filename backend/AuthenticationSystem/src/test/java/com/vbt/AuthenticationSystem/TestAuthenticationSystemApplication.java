package com.vbt.AuthenticationSystem;

import org.springframework.boot.SpringApplication;

public class TestAuthenticationSystemApplication {

	public static void main(String[] args) {
		SpringApplication.from(AuthenticationSystemApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
