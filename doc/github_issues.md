# GitHub Issues & Proje Yönetimi

Bu doküman, **VBT Authentication System** projesi için hazırlanmış GitHub Issues listesini içermektedir.

---

## Issue #1 - Backend Altyapısının Kurulması

### Sorumlu
- Alper Bilgin

### Açıklama
Spring Boot projesinin temel mimarisinin oluşturulması.

### Yapılacaklar
- [ ] Spring Boot 3 projesini oluştur
- [ ] Java 21 yapılandırması
- [ ] Maven yapılandırması
- [ ] Katmanlı mimari oluştur
    - Controller
    - Service
    - Repository
    - DTO
    - Entity
    - Config
    - Security
- [ ] PostgreSQL bağlantısı
- [ ] Docker Compose oluştur
- [ ] Global Exception Handler
- [ ] Validation altyapısı
- [ ] Swagger (OpenAPI)
- [ ] Logging altyapısı

### Çıktılar
- Çalışan Spring Boot projesi
- PostgreSQL bağlantısı
- Swagger arayüzü

---

## Issue #2 - Authentication & Authorization

### Sorumlu
- Alper Bilgin

### Açıklama
JWT tabanlı kimlik doğrulama sisteminin geliştirilmesi.

### Yapılacaklar
- [ ] User Entity
- [ ] Register Endpoint
- [ ] Login Endpoint
- [ ] JWT Access Token
- [ ] JWT Refresh Token
- [ ] BCrypt/Argon2 Password Encoder
- [ ] Spring Security Configuration
- [ ] Authentication Filter
- [ ] Authorization Filter
- [ ] Protected Endpoint Testleri

### Çıktılar
- Güvenli giriş sistemi
- JWT doğrulama mekanizması

---

## Issue #3 - Refresh Token & Redis

### Sorumlu
- Alper Bilgin

### Açıklama
Refresh Token yönetimi ve Redis entegrasyonu.

### Yapılacaklar
- [ ] Redis entegrasyonu
- [ ] Refresh Token Endpoint
- [ ] Logout Endpoint
- [ ] Refresh Token Blacklist
- [ ] Token Rotation
- [ ] Rate Limiting (Bucket4j)
- [ ] Brute Force Koruması

### Çıktılar
- Güvenli oturum yönetimi
- Redis destekli token sistemi

---

## Issue #4 - Backend Testing

### Sorumlu
- Alper Bilgin

### Açıklama
Backend testlerinin hazırlanması.

### Yapılacaklar
- [ ] Unit Testler
- [ ] Integration Testler
- [ ] Testcontainers
- [ ] PostgreSQL Container
- [ ] Redis Container
- [ ] Authentication Testleri
- [ ] Refresh Token Testleri

### Çıktılar
- Test kapsamı yüksek backend

---

## Issue #5 - Flutter Projesinin Kurulması

### Sorumlu
- Hanife İnci Kösem

### Açıklama
Flutter uygulamasının temel altyapısının hazırlanması.

### Yapılacaklar
- [ ] Flutter projesi oluştur
- [ ] Klasör yapısını oluştur
- [ ] Riverpod/BLoC kurulumu
- [ ] Dio kurulumu
- [ ] flutter_secure_storage kurulumu
- [ ] Tema yapısı
- [ ] Routing sistemi

### Çıktılar
- Çalışan Flutter altyapısı

---

## Issue #6 - Login & Register UI

### Sorumlu
- Hanife İnci Kösem

### Açıklama
Kimlik doğrulama ekranlarının geliştirilmesi.

### Yapılacaklar
- [ ] Login ekranı
- [ ] Register ekranı
- [ ] Form Validation
- [ ] Loading State
- [ ] Error State
- [ ] Success State

### Çıktılar
- Çalışan giriş ekranları

---

## Issue #7 - API Integration

### Sorumlu
- Hanife İnci Kösem

### Açıklama
Backend servisleri ile Flutter uygulamasının entegrasyonu.

### Yapılacaklar
- [ ] Dio Client
- [ ] API Service
- [ ] Login API
- [ ] Register API
- [ ] Token Saklama
- [ ] Logout

### Çıktılar
- Backend ile çalışan mobil uygulama

---

## Issue #8 - Refresh Token Flow

### Sorumlu
- Hanife İnci Kösem

### Açıklama
Dio Interceptor kullanılarak otomatik token yenileme mekanizmasının geliştirilmesi.

### Yapılacaklar
- [ ] Dio Interceptor
- [ ] 401 Hatasını Yakalama
- [ ] Refresh Token İsteği
- [ ] Yeni Token Kaydetme
- [ ] Eski İsteği Tekrarlama

### Çıktılar
- Kullanıcının fark etmediği oturum yenileme sistemi

---

## Issue #9 - End-to-End Testing

### Sorumlu
- Hanife İnci Kösem

### Açıklama
Mobil uygulamanın uçtan uca test edilmesi.

### Yapılacaklar
- [ ] Maestro kurulumu
- [ ] Login Senaryosu
- [ ] Register Senaryosu
- [ ] Refresh Token Senaryosu
- [ ] Logout Senaryosu

### Çıktılar
- Otomatik çalışan E2E testleri

---

## Issue #10 - Proje Dokümantasyonu

### Sorumlular
- Alper Bilgin
- Hanife İnci Kösem

### Açıklama
Projenin kurulum ve kullanım dokümantasyonunun hazırlanması.

### Yapılacaklar
- [ ] README.md
- [ ] Kurulum Adımları
- [ ] Docker Kurulumu
- [ ] API Dokümantasyonu
- [ ] Kullanım Senaryoları
- [ ] Mimari Diyagram

### Çıktılar
- Tam proje dokümantasyonu
