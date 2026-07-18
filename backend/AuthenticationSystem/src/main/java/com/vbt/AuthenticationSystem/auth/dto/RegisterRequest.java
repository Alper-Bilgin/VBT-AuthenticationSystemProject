package com.vbt.AuthenticationSystem.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
        @NotBlank(message = "E-posta adresi boş bırakılamaz.")
        @Email(message = "Geçerli bir e-posta adresi giriniz.")
        String email,

        @NotBlank(message = "Şifre boş bırakılamaz.")
        @Size(min = 8, max = 64, message = "Şifre 8 ile 64 karakter arasında olmalıdır.")
        @Pattern(
                regexp = "^(?=.*[A-Z])(?=.*[0-9]).*$",
                message = "Şifre en az bir büyük harf ve bir rakam içermelidir."
        )
        String password
) {
}
