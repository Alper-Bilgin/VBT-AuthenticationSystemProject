# Authentication System — Backend

Spring Boot 3 tabanlı, JWT Access Token + Refresh Token mimarisine sahip, Redis destekli kimlik doğrulama sistemi. Bu proje VBT staj programı kapsamında iki kişilik bir ekip tarafından geliştirilmektedir.

Bu doküman, projeyi hiç görmemiş biri bile takip edebilsin diye **adım adım ve detaylı** yazılmıştır. Bir adımı atlarsanız sonraki adımlar çalışmayabilir, o yüzden sırayla ilerleyin.

---

## İçindekiler

1. [Proje Hakkında](#1-proje-hakkında)
2. [Kullanılan Teknolojiler](#2-kullanılan-teknolojiler)
3. [Gereksinimler (Kurulu Olması Gerekenler)](#3-gereksinimler-kurulu-olması-gerekenler)
4. [Projeyi İlk Kez Ayağa Kaldırma](#4-projeyi-i̇lk-kez-ayağa-kaldırma)
5. [Ortam Değişkenleri (application.yml) Açıklaması](#5-ortam-değişkenleri-applicationyml-açıklaması)
6. [Projeyi Çalıştırma](#6-projeyi-çalıştırma)
7. [API Dokümantasyonu (Swagger)](#7-api-dokümantasyonu-swagger)
8. [Kimlik Doğrulama Akışı (Authentication Flow)](#8-kimlik-doğrulama-akışı-authentication-flow)
9. [Endpoint Listesi ve Örnek İstekler](#9-endpoint-listesi-ve-örnek-i̇stekler)
10. [Hata Formatı (ApiErrorResponse)](#10-hata-formatı-apierrorresponse)
11. [Rate Limiting (İstek Sınırlandırma)](#11-rate-limiting-i̇stek-sınırlandırma)
12. [Proje Klasör Yapısı](#12-proje-klasör-yapısı)
13. [Testleri Çalıştırma](#13-testleri-çalıştırma)
14. [Sık Karşılaşılan Hatalar ve Çözümleri](#14-sık-karşılaşılan-hatalar-ve-çözümleri)
15. [Mobil (Flutter) Ekibi İçin Notlar](#15-mobil-flutter-ekibi-i̇çin-notlar)
16. [Ekip](#16-ekip)

---

## 1. Proje Hakkında

Bu proje, Spring Boot ile geliştirilen güvenli bir REST API'nin Flutter mobil uygulaması ile entegre çalışmasını sağlayan bir Authentication (Kimlik Doğrulama) Sistemidir.

**Neler var:**
- Güvenli kullanıcı kayıt ve giriş sistemi
- JWT tabanlı Access Token + veritabanında hash'lenmiş Refresh Token mimarisi
- Redis ile IP bazlı Rate Limiting (brute-force koruması)
- Argon2/BCrypt ile güvenli parola saklama
- Swagger/OpenAPI dokümantasyonu
- Docker desteği (Postgres + Redis konteynerize)
- Testcontainers ile entegrasyon testleri
- Standart, tutarlı hata formatı (RFC 7807 benzeri)

---

## 2. Kullanılan Teknolojiler

| Katman | Teknoloji |
|---|---|
| Dil | Java 21 |
| Framework | Spring Boot 3.5.4 |
| Güvenlik | Spring Security 6 |
| Veritabanı | PostgreSQL 16 |
| Cache / Rate Limit | Redis 7 (Redisson + Bucket4j) |
| ORM | Spring Data JPA / Hibernate |
| Token | JWT (jjwt 0.12.5) |
| Dokümantasyon | Springdoc OpenAPI (Swagger UI) |
| Test | JUnit 5, Testcontainers, MockMvc |
| Konteyner | Docker, Docker Compose |
| Build Tool | Maven |

---

## 3. Gereksinimler (Kurulu Olması Gerekenler)

Projeyi çalıştırmadan önce bilgisayarınızda şunların kurulu olması gerekiyor. Sırayla kontrol edin:

### 3.1. Java 21 (JDK)
Terminalde şu komutu çalıştırın:
```bash
java -version
```
Çıktıda `21` görmelisiniz. Görmüyorsanız [Eclipse Temurin JDK 21](https://adoptium.net/temurin/releases/?version=21) adresinden indirip kurun.

> **Not:** IntelliJ IDEA kullanıyorsanız, `File > Project Structure > Project SDK` üzerinden JDK 21'i seçtiğinizden emin olun.

### 3.2. Maven
IntelliJ IDEA kendi içinde Maven ile geldiği için genelde ayrıca kurmanıza gerek yok. Terminalden kontrol etmek isterseniz:
```bash
mvn -version
```

### 3.3. Docker Desktop
Postgres ve Redis'i konteyner olarak çalıştıracağız, bu yüzden Docker şart.
- Windows/Mac: [Docker Desktop](https://www.docker.com/products/docker-desktop/) indirip kurun.
- Kurulumdan sonra Docker Desktop uygulamasını **açık tutun** — arka planda çalışıyor olması gerekiyor, yoksa `docker-compose up` komutu hata verir.
- Kontrol için terminalde:
```bash
docker --version
docker-compose --version
```

### 3.4. Git
Projeyi klonlamak için gerekli. Zaten kuruluysa atlayabilirsiniz.

### 3.5. Bir IDE (Önerilen: IntelliJ IDEA)
Community veya Ultimate sürüm, ikisi de bu proje için yeterli.

---

## 4. Projeyi İlk Kez Ayağa Kaldırma

Bu bölümü **sırasıyla** takip edin, adım atlamayın.

### Adım 1 — Projeyi klonlayın

```bash
git clone <repo-url>
cd VBT-AuthenticationSystemProject/backend/AuthenticationSystem
```

> Repo yapımızda `backend` ve `mobile` diye iki ayrı klasör var, biz sadece `backend/AuthenticationSystem` içinde çalışıyoruz.

### Adım 2 — Docker konteynerlerini (Postgres + Redis) ayağa kaldırın

Projenin kök dizininde (`docker-compose.yml` dosyasının bulunduğu yer) şu komutu çalıştırın:

```bash
docker-compose up -d
```

`-d` parametresi konteynerlerin arka planda (detached) çalışmasını sağlar, terminali kilitlemez.

Bu komut şunları yapar:
- PostgreSQL'i `5433` portunda ayağa kaldırır (dikkat: **5432 değil**, çünkü çoğu geliştiricinin bilgisayarında yerel bir Postgres zaten 5432'yi kullanıyor olabilir, çakışmayı önlemek için 5433 seçtik).
- Redis'i standart `6379` portunda ayağa kaldırır.

**Konteynerlerin gerçekten çalıştığını doğrulayın:**
```bash
docker ps
```
Çıktıda `login_postgres` ve `login_redis` isimli iki konteyner **"Up"** durumunda görünmeli. Görünmüyorsa Docker Desktop'ın açık olduğundan emin olun ve komutu tekrar deneyin.

### Adım 3 — `application.yml` dosyasını kontrol edin / oluşturun

`src/main/resources/application.yml` dosyası projede zaten mevcut olmalı. İçeriği [Bölüm 5](#5-ortam-değişkenleri-applicationyml-açıklaması)'te detaylıca anlatılıyor. Şimdilik önemli olan: bu dosyanın **Postgres'e 5433 portundan, Redis'e 6379 portundan** bağlanacak şekilde ayarlanmış olması.

### Adım 4 — JWT Secret'ı ayarlayın (ÇOK ÖNEMLİ)

`application.yml` içinde `jwt.secret` alanı bulunuyor. Bu değer **en az 32 karakter uzunluğunda, Base64 formatlı** bir string olmalı. Değilse uygulama ilk login denemesinde `WeakKeyException` hatası fırlatır.

Kendi secret'ınızı üretmek isterseniz terminalde:
```bash
# Linux/Mac
openssl rand -base64 32

# Windows (PowerShell)
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 255 }))
```

Çıkan değeri `application.yml`'deki `jwt.secret` alanına yapıştırın.

### Adım 5 — Projeyi IntelliJ'de açın ve Maven bağımlılıklarını indirin

IntelliJ IDEA'da `File > Open` ile `backend/AuthenticationSystem` klasörünü açın. IntelliJ otomatik olarak `pom.xml`'i algılayıp Maven bağımlılıklarını indirmeye başlayacaktır. Sağ alt köşede bir yükleme çubuğu göreceksiniz, bitmesini bekleyin (ilk seferde birkaç dakika sürebilir).

Elle indirmek isterseniz terminalde:
```bash
mvn clean install -DskipTests
```
(`-DskipTests` koyuyoruz çünkü testler Docker + Testcontainers gerektiriyor, ilk kurulumda buna gerek yok.)

### Adım 6 — Uygulamayı çalıştırın

IntelliJ'de `AuthenticationSystemApplication.java` dosyasını bulup yanındaki yeşil ▶️ (Run) butonuna basın.

Ya da terminalden:
```bash
mvn spring-boot:run
```

Konsol çıktısında şunu görürseniz her şey yolunda demektir:
```
Tomcat started on port 8080 (http) with context path '/'
Started AuthenticationSystemApplication in X.XXX seconds
```

### Adım 7 — Uygulamanın gerçekten çalıştığını doğrulayın

Tarayıcıda şu adresi açın:
```
http://localhost:8080/swagger-ui.html
```
Swagger UI ekranını görüyorsanız kurulum başarılı. 🎉

---

## 5. Ortam Değişkenleri (application.yml) Açıklaması

`src/main/resources/application.yml` dosyasının tam içeriği ve her satırın ne işe yaradığı:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5433/login_db   # Docker'daki Postgres'e bağlanır (port 5433!)
    username: admin
    password: securepassword123
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: update      # Tabloları Entity sınıflarından otomatik oluşturur/günceller (SADECE geliştirme için)
    show-sql: true          # Konsola çalışan SQL sorgularını yazdırır (debug için faydalı)
    properties:
      hibernate:
        format_sql: true

  data:
    redis:
      host: localhost
      port: 6379

jwt:
  secret: <32+ karakterlik Base64 string>    # Bkz. Bölüm 4, Adım 4
  access-token-expiration: 900000            # 15 dakika (milisaniye cinsinden)
  refresh-token-expiration: 604800000        # 7 gün (milisaniye cinsinden)

app:
  security:
    rate-limit:
      enabled: true    # false yaparsanız rate limiting devre dışı kalır (test ortamında false)
```

**⚠️ Güvenlik Notu:** Bu dosyadaki `password` ve `jwt.secret` gibi değerler **gerçek/production ortamında asla GitHub'a pushlanmamalı**. Şu an staj/geliştirme aşamasında olduğumuz için bu şekilde bırakıyoruz, ama ileride `.env` dosyasına veya ortam değişkenlerine taşımayı planlıyoruz.

---

## 6. Projeyi Çalıştırma

Her gün çalışmaya başlarken izlemeniz gereken sıra:

```bash
# 1. Docker Desktop'ın açık olduğundan emin olun

# 2. Konteynerleri başlatın (eğer kapatmadıysanız bu adıma gerek yok)
docker-compose up -d

# 3. Konteynerlerin ayakta olduğunu kontrol edin
docker ps

# 4. Uygulamayı IntelliJ'den veya terminalden çalıştırın
mvn spring-boot:run
```

**Konteynerleri durdurmak isterseniz:**
```bash
docker-compose stop
```

**Konteynerleri tamamen silmek isterseniz (veritabanındaki veriler de silinir!):**
```bash
docker-compose down -v
```

---

## 7. API Dokümantasyonu (Swagger)

Uygulama çalışırken tarayıcıdan şu adrese gidin:

```
http://localhost:8080/swagger-ui.html
```

Burada:
- Tüm endpoint'leri görebilir,
- Her endpoint'in hangi request body'yi beklediğini, hangi response'ları dönebileceğini (200, 400, 401, 409, 429 vb.) inceleyebilir,
- **"Try it out"** butonuyla tarayıcıdan doğrudan istek atıp test edebilirsiniz.

Korumalı bir endpoint'i test etmek isterseniz sağ üstteki **"Authorize"** butonuna tıklayıp, login'den aldığınız `access_token`'ı `Bearer <token>` formatında girin.

Ham OpenAPI JSON şemasına ihtiyacınız olursa (örneğin Postman'e import etmek için):
```
http://localhost:8080/v3/api-docs
```

---

## 8. Kimlik Doğrulama Akışı (Authentication Flow)

Sistemin mantığını adım adım anlatalım:

1. **Kayıt (Register):** Kullanıcı email + şifre gönderir. Şifre Argon2/BCrypt ile hash'lenip veritabanına kaydedilir. Şifrenin kendisi **hiçbir zaman** düz metin olarak saklanmaz.

2. **Giriş (Login):** Kullanıcı email + şifre gönderir. Doğrulama başarılıysa backend iki şey üretir:
   - **Access Token** (JWT, 15 dakika geçerli): Her API isteğinde `Authorization: Bearer <token>` header'ı olarak gönderilir.
   - **Refresh Token** (rastgele üretilmiş 256-bit güvenli string, 7 gün geçerli): Veritabanında **SHA-256 hash'i** olarak saklanır, düz metin hali sadece kullanıcıya bir kez dönülür.

3. **Korumalı istek:** Flutter uygulaması her API isteğinde Access Token'ı header'a ekler. Backend'deki `JwtAuthenticationFilter` bu token'ı doğrular.

4. **Access Token süresi dolduğunda:** Flutter tarafındaki Dio Interceptor, 401 hatası aldığında otomatik olarak `/api/v1/auth/refresh` endpoint'ine Refresh Token'ı gönderir, yeni bir Access Token alır ve orijinal isteği otomatik tekrar dener. Kullanıcı bu süreci fark etmez.

5. **Çıkış (Logout):** Refresh Token backend'e gönderilir, veritabanında `is_revoked = true` yapılır. Artık o token ile yeni Access Token alınamaz.

6. **Tek Oturum Politikası:** Bir kullanıcı yeni bir cihazdan/tarayıcıdan login olduğunda, o kullanıcının **önceki tüm Refresh Token'ları otomatik iptal edilir**. Yani aynı anda sadece bir aktif oturum olabilir. (Bu bilinçli bir tasarım kararıdır — mobil taraf bu konuda bilgilendirilmelidir.)

---

## 9. Endpoint Listesi ve Örnek İstekler

Base URL: `http://localhost:8080/api/v1/auth`

### 9.1. Kayıt Ol — `POST /register`

**Request Body:**
```json
{
  "email": "kullanici@example.com",
  "password": "Sifre123!"
}
```

> Şifre kuralı: en az 8, en fazla 64 karakter, en az bir büyük harf ve bir rakam içermeli.

**Başarılı Yanıt:** `201 Created` (body dönmez)

**Olası Hatalar:**
| Kod | Sebep |
|---|---|
| 400 | Email formatı geçersiz veya şifre kuralına uymuyor |
| 409 | Bu email zaten kayıtlı |
| 429 | Bu IP'den dakikada 3'ten fazla kayıt denemesi yapıldı |

---

### 9.2. Giriş Yap — `POST /login`

**Request Body:**
```json
{
  "email": "kullanici@example.com",
  "password": "Sifre123!"
}
```

**Başarılı Yanıt:** `200 OK`
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "xY9k2mP...",
  "token_type": "Bearer",
  "expires_in": 900000,
  "user": {
    "id": 1,
    "email": "kullanici@example.com",
    "role": "USER",
    "createdAt": "2026-07-19T10:00:00"
  }
}
```

**Olası Hatalar:**
| Kod | Sebep |
|---|---|
| 400 | İstek formatı geçersiz |
| 401 | Email veya şifre hatalı |
| 429 | Bu IP'den dakikada 5'ten fazla giriş denemesi yapıldı |

---

### 9.3. Token Yenile — `POST /refresh`

**Request Body:**
```json
{
  "refreshToken": "xY9k2mP..."
}
```

**Başarılı Yanıt:** `200 OK`
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs... (yeni)",
  "refresh_token": "xY9k2mP... (aynı token geri döner)",
  "token_type": "Bearer",
  "expires_in": 900000
}
```
> Not: `user` alanı bu endpoint'te `null` döner (performans için ekstra kullanıcı sorgusu yapılmıyor).

**Olası Hatalar:**
| Kod | Sebep |
|---|---|
| 401 | Refresh token geçersiz, süresi dolmuş veya iptal edilmiş |

---

### 9.4. Çıkış Yap — `POST /logout`

**Request Body:**
```json
{
  "refreshToken": "xY9k2mP..."
}
```

**Başarılı Yanıt:** `204 No Content` (body dönmez)

> Bu endpoint public'tir, yani Access Token gerektirmez — sadece geçerli bir Refresh Token bilmeniz yeterlidir (token zaten gizli bir bilgi olduğu için bu güvenli kabul edilir).

---

## 10. Hata Formatı (ApiErrorResponse)

Sistemdeki **tüm hatalar** aynı standart JSON formatında döner (RFC 7807 Problem Details'e benzer):

```json
{
  "title": "Kayıt Hatası",
  "status": 409,
  "detail": "Bu e-posta adresi zaten kullanımda.",
  "instance": "/api/v1/auth/register",
  "timestamp": "2026-07-19T10:00:00Z",
  "invalidParams": null
}
```

Alanların anlamı:
- `title`: Hatanın kısa başlığı (kategori)
- `status`: HTTP durum kodu
- `detail`: Kullanıcıya gösterilebilecek açıklama
- `instance`: Hatanın oluştuğu endpoint yolu
- `timestamp`: Hatanın oluştuğu an (UTC, ISO-8601 formatında)
- `invalidParams`: Sadece validasyon hatalarında dolu olur, hangi alanın neden geçersiz olduğunu gösterir. Örnek:
```json
"invalidParams": {
  "email": "Geçerli bir e-posta adresi giriniz.",
  "password": "Şifre en az bir büyük harf ve bir rakam içermelidir."
}
```

Mobil tarafın hata mesajlarını göstermek için sadece `detail` (ve validasyon varsa `invalidParams`) alanına bakması yeterli.

---

## 11. Rate Limiting (İstek Sınırlandırma)

Brute-force saldırılarını (aynı IP'den art arda şifre deneme gibi) önlemek için Redis tabanlı bir istek sınırlandırma sistemi var:

| Endpoint | Limit |
|---|---|
| `/api/v1/auth/login` | Dakikada 5 istek (IP başına) |
| `/api/v1/auth/register` | Dakikada 3 istek (IP başına) |

Limit aşıldığında `429 Too Many Requests` döner. Mobil tarafın bu durumu kullanıcıya "Çok fazla deneme yaptınız, lütfen biraz bekleyin" şeklinde göstermesi önerilir.

> **Geliştirici notu:** Test ortamında bu özellik `application-test.yml`'de `app.security.rate-limit.enabled: false` ile kapatılmıştır, aksi halde testler art arda çalışırken birbirini rate limit'e takılıp yanlış sonuç verir.

---

## 12. Proje Klasör Yapısı

```
src/main/java/com/vbt/AuthenticationSystem/
│
├── auth/                           # Kimlik doğrulama ile ilgili her şey
│   ├── controller/                 # AuthController — HTTP endpoint'leri
│   ├── dto/                        # LoginRequest, RegisterRequest, TokenResponse vb.
│   ├── entity/                     # RefreshToken entity'si
│   ├── repository/                 # RefreshTokenRepository
│   └── service/                    # AuthenticationService, JwtService, RefreshTokenService
│
├── user/                           # Kullanıcı ile ilgili her şey
│   ├── dto/                        # UserResponse
│   ├── entity/                     # User, Role
│   └── repository/                 # UserRepository
│
├── infrastructure/                 # Teknik altyapı (framework'e bağlı kodlar)
│   ├── config/                     # OpenApiConfig, RateLimitConfig, RedissonConfig, WebMvcConfig
│   ├── exception/                  # Özel exception sınıfları + GlobalExceptionHandler
│   ├── security/                   # SecurityConfiguration, JwtAuthenticationFilter, ApplicationConfig, RateLimitInterceptor
│   └── utils/                      # ErrorResponseWriter
│
└── AuthenticationSystemApplication.java   # main metodu

src/main/resources/
├── application.yml                 # Ana konfigürasyon dosyası

src/test/java/com/vbt/AuthenticationSystem/
├── BaseIntegrationTest.java        # Testcontainers altyapısı (tüm testler bunu extend eder)
└── auth/controller/
    └── AuthControllerTest.java     # Uçtan uca (integration) testler

src/test/resources/
└── application-test.yml            # Test ortamı konfigürasyonu

docker-compose.yml                  # Postgres + Redis konteynerleri
```

**Mimari mantık:** `auth` ve `user` paketleri **domain** (iş mantığı) katmanını, `infrastructure` paketi ise framework/teknik detayları (güvenlik, hata yönetimi, config) temsil eder. Bu ayrım, ileride iş mantığını değiştirmeden teknik altyapıyı (örneğin JWT kütüphanesini) değiştirebilmeyi kolaylaştırır.

---

## 13. Testleri Çalıştırma

**Önkoşul:** Docker Desktop açık olmalı — testler gerçek Postgres ve Redis konteynerlerini (Testcontainers ile) otomatik ayağa kaldırıp kullanır, sizin elle `docker-compose up` yapmanıza gerek yoktur, testler bunu kendisi halleder.

**Tüm testleri çalıştırmak için:**
```bash
mvn test
```

**IntelliJ'den tek bir test sınıfını çalıştırmak için:** `AuthControllerTest.java` dosyasını açıp sınıf adının yanındaki yeşil ▶️ butonuna tıklayın.

**Testler ne yapıyor?**
- Her test öncesi geçici bir Postgres ve Redis konteyneri (Docker üzerinde) ayağa kalkar.
- Gerçek HTTP istekleri simüle edilir (MockMvc ile).
- Register → Login → Refresh → Logout akışının tamamı, hem başarılı hem hatalı senaryolarla test edilir.
- Testler bitince konteynerler otomatik silinir, sisteminizde kalıcı bir iz bırakmaz.

**İlk çalıştırmada yavaş olabilir** (Docker imajları indirilir), sonraki çalıştırmalarda çok daha hızlı olacaktır.

---

## 14. Sık Karşılaşılan Hatalar ve Çözümleri

### "Connection refused" / Postgres'e bağlanamıyor
- Docker Desktop açık mı kontrol edin.
- `docker ps` ile `login_postgres` konteynerinin çalıştığını doğrulayın.
- `application.yml`'deki portun **5433** olduğundan emin olun (5432 değil!).

### `WeakKeyException` hatası
- `application.yml`'deki `jwt.secret` değeri 32 karakterden kısa. [Bölüm 4, Adım 4](#adım-4--jwt-secreti-ayarlayın-çok-önemli)'ü tekrar uygulayın.

### Login/Register'da beklenmedik 500 hatası
- Konsol loglarına bakın, `GlobalExceptionHandler` her 500 hatasını loglar (`log.error(...)`). Genelde bir NPE veya beklenmeyen bir exception türüdür.

### Testler "port already in use" hatası veriyor
- Muhtemelen elle `docker-compose up` ile ayağa kaldırdığınız Postgres/Redis, Testcontainers'ın kendi ayağa kaldırdığı konteynerlerle çakışıyor olabilir. Testler kendi izole konteynerlerini kullanır, elle ayağa kaldırdıklarınızla karışmaz — bu hatayı alırsanız `docker ps` ile ekstradan çalışan bir şey olup olmadığını kontrol edin.

### `429 Too Many Requests` hatası (geliştirme sırasında)
- Login/Register'ı art arda çok fazla denediyseniz bu normaldir, 1 dakika bekleyin. Test ortamında bu sorun yaşanmaz çünkü `rate-limit.enabled: false`.

### Swagger UI açılmıyor (`http://localhost:8080/swagger-ui.html`)
- Uygulamanın gerçekten çalıştığından emin olun (konsolda `Tomcat started on port 8080` yazısını arayın).
- Port 8080 başka bir uygulama tarafından kullanılıyor olabilir, konsol loglarında hata var mı kontrol edin.

---

## 15. Mobil (Flutter) Ekibi İçin Notlar

- **Base URL (local geliştirme):** `http://localhost:8080/api/v1/auth` (Android emulator kullanıyorsanız `localhost` yerine `10.0.2.2` kullanmanız gerekebilir).
- Access Token'ı her istekte `Authorization: Bearer <token>` header'ında gönderin.
- Access Token 15 dakikada bir sona erer — 401 aldığınızda Dio Interceptor ile otomatik `/refresh` çağırıp orijinal isteği tekrar deneyin.
- **Tek oturum politikası:** Kullanıcı başka bir cihazdan login olursa, önceki cihazdaki refresh token otomatik geçersiz olur. Bu durumda kullanıcıya "Oturumunuz başka bir cihazda açıldı" gibi bir mesaj gösterip login ekranına yönlendirmeniz gerekebilir.
- Tüm hata yanıtları [Bölüm 10](#10-hata-formatı-apierrorresponse)'daki standart formatta gelir, `detail` alanını kullanıcıya gösterebilirsiniz.
- Swagger UI üzerinden (`/swagger-ui.html`) tüm endpoint'leri ve örnek request/response'ları inceleyebilirsiniz — backend'e sormadan önce oraya bakmanız çoğu sorunuzu çözecektir.

---

## 16. Ekip

**Backend Developer**
Alper Bilgin — [@Alper-Bilgin](https://github.com/Alper-Bilgin)
Sorumluluklar: Spring Boot Backend, Spring Security, JWT Authentication, Refresh Token, Redis, Rate Limiting, API Development, Swagger, Unit & Integration Testleri

**Mobile Developer**
Hanife İnci Kösem — [@inci928](https://github.com/inci928)
Sorumluluklar: Flutter UI, API Entegrasyonu, Dio Interceptor, Token Yönetimi, Secure Storage, State Management, E2E Testleri

---

## Bir Şey Anlamadıysanız

Bu README'de anlamadığınız veya eksik bulduğunuz bir şey varsa, direkt sorun — dokümanı birlikte güncelleyelim. Kod her değiştiğinde bu dosyayı da güncel tutmaya çalışacağız.

---

## 17. Geliştirici

**Alper Bilgin**

- Linktree: https://linktr.ee/Alper_Bilgin
- website: https://alperbilgin.vercel.app/
