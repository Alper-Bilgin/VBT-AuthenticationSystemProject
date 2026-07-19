# 🔐 Authentication System — Mobile (Flutter)

Flutter tabanlı, **Material 3 tasarımlı**, **Riverpod durum yönetimli** ve **Flutter Secure Storage güvenli veri saklama altyapısına** sahip modern kimlik doğrulama mobil uygulaması.

Bu proje, **VBT Staj Programı** kapsamında iki kişilik ekip tarafından geliştirilmektedir.

Bu doküman; mobil uygulamanın mimarisini, kullanılan teknolojileri, tasarım yaklaşımını, kurulum adımlarını ve backend entegrasyon yapısını açıklamak amacıyla hazırlanmıştır.

---

# 📌 İçindekiler

1. [Proje Hakkında](#1-proje-hakkında)
2. [Kullanılan Teknolojiler ve Paketler](#2-kullanılan-teknolojiler-ve-paketler)
3. [Gereksinimler ve Kurulum](#3-gereksinimler-ve-kurulum)
4. [Proje Klasör Yapısı (Kurumsal Mimari)](#4-proje-klasör-yapısı-kurumsal-mimari)
5. [Tasarım ve UI Standartları](#5-tasarım-ve-ui-standartları)
6. [Mevcut Durum ve MVP İlerlemesi](#6-mevcut-durum-ve-mvp-ilerlemesi)
7. [Backend Entegrasyon Notları](#7-backend-entegrasyon-notları)
8. [Uygulamayı Çalıştırma](#8-uygulamayı-çalıştırma)
9. [Ekip](#9-ekip)

---

# 1. Proje Hakkında

Bu proje, backend tarafında geliştirilen **Spring Boot 3 + JWT Authentication** altyapısı ile entegre çalışacak Flutter mobil istemcisidir.

## Öne Çıkan Özellikler

- **Modern UI:** Material 3 standartlarına uygun, sade ve kullanıcı odaklı tasarım.
- **Güvenli Kimlik Doğrulama:** Email ve şifre validasyonları.
- **Network Yönetimi:** Dio ile merkezi API iletişim altyapısı.
- **State Management:** Riverpod ile reaktif ve test edilebilir durum yönetimi.
- **Secure Storage:** Token bilgilerinin güvenli şekilde saklanması.

---

# 2. Kullanılan Teknolojiler ve Paketler

Proje, sürdürülebilir ve ölçeklenebilir bir mobil altyapı oluşturmak amacıyla modern Flutter teknolojileri kullanılarak geliştirilmiştir.

## ⚙️ Flutter & Dart

- **Flutter SDK (3.44.x)**
- **Dart SDK (3.12.x)**

Mobil uygulamanın geliştirme framework'ü ve programlama dilidir.

---

## 🏗️ State Management

### flutter_riverpod

UI katmanı ile iş mantığının ayrıştırılmasını sağlar.

Avantajları:

- Reactive state yönetimi
- Test edilebilir yapı
- Ölçeklenebilir mimari

---

## 🌐 Network Layer

### Dio

Backend API iletişimi için kullanılan HTTP istemcisidir.

Sağladığı özellikler:

- Merkezi API yönetimi
- Interceptor desteği
- Hata yönetimi
- Token işlemleri

---

## 🔒 Secure Storage

### flutter_secure_storage

Kullanıcı oturum bilgilerinin güvenli şekilde saklanmasını sağlar.

Saklanan veriler:

- Access Token
- Refresh Token

Platform güvenliği:

- Android → Keystore
- iOS → Keychain

---

## 🎨 UI Framework

### Material 3

Modern, sade ve erişilebilir mobil arayüz geliştirmek için kullanılmaktadır.

---

# 3. Gereksinimler ve Kurulum

Bu bölüm, geliştirme ortamının hazırlanması ve uygulamanın çalıştırılması için gerekli adımları içerir.

---

## 3.1 Geliştirme Ortamı Gereksinimleri

| Gereksinim | Açıklama |
|-|-|
| Flutter SDK | Mobil uygulama geliştirme framework'ü |
| Dart SDK | Flutter programlama dili |
| Android Studio | Emulator ve Android geliştirme ortamı |
| Visual Studio Code | Kod editörü |
| Git | Versiyon kontrol sistemi |

Önerilen sürümler:

| Teknoloji | Versiyon |
|-|-|
| Flutter | 3.44.x |
| Dart | 3.12.x |
| Java | 17+ |

---

## 3.2 Flutter Ortam Kontrolü

Flutter ortamını kontrol etmek için:

```bash
flutter doctor
```

komutu çalıştırılır.

---

## 3.3 Paketlerin Yüklenmesi

Proje dizininde:

```bash
flutter pub get
```

komutu çalıştırılır.

---

# 4. Proje Klasör Yapısı (Kurumsal Mimari)

Mobil uygulama, sürdürülebilir ve ölçeklenebilir bir yapı oluşturmak amacıyla **Clean Architecture** prensipleri temel alınarak geliştirilmiştir.

Sağladığı avantajlar:

- UI ve business logic ayrımı
- Test edilebilir yapı
- Kolay bakım
- Ölçeklenebilir geliştirme

---

## 4.1 Genel Klasör Yapısı

```text
lib/

├── core/

├── features/

└── main.dart
```

---

## 4.2 Core Katmanı

Uygulama genelinde kullanılan ortak yapıları içerir.

```text
core/

├── constants/
├── theme/
├── network/
├── storage/
└── widgets/
```

İçerdiği yapılar:

- Tema yönetimi
- API bağlantısı
- Secure storage işlemleri
- Ortak UI componentleri

---

## 4.3 Feature Katmanı

Her özellik kendi bağımsız yapısı içerisinde geliştirilir.

Örnek:

```text
features/

└── authentication/
```

Katmanlar:

```text
authentication/

├── data/

├── domain/

└── presentation/
```

---

# 5. Tasarım ve UI Standartları

Mobil uygulamanın tasarım süreci, kullanıcı deneyimi (UX) ve görsel tutarlılık (UI Consistency) prensipleri doğrultusunda geliştirilmiştir.

Tasarım hedefleri:

- Modern mobil deneyim oluşturmak
- Kullanıcı akışını kolaylaştırmak
- Tutarlı bir Design System oluşturmak
- Ölçeklenebilir UI yapısı sağlamak

Uygulama tasarımında **Material 3 Design System** kullanılmaktadır.

---

# 5.1 Tasarım Felsefesi

## Minimalizm

Tasarımlarda:

- Temiz boşluk kullanımı
- Dengeli içerik yerleşimi
- Net görsel hiyerarşi

ön plandadır.

---

## Kullanıcı Odaklı Tasarım

Her ekran belirli bir kullanıcı amacı doğrultusunda tasarlanır.

Örneğin Login ekranında:

- Form kullanımı kolaylaştırılır.
- Ana aksiyon öne çıkarılır.
- Gereksiz öğeler azaltılır.

---

# 5.2 Design System

Uygulamada merkezi bir tasarım sistemi oluşturulmuştur.

```text
Design System

├── Colors
├── Typography
├── Spacing
├── Radius
├── Components
└── Icons
```

---

# 5.3 Component Yapısı

Tekrar kullanılabilir UI bileşenleri geliştirilmiştir.

Örnek:

- CustomTextField
- PrimaryButton
- Loading Widget

Avantajları:

- Kod tekrarını azaltır.
- Tasarım bütünlüğü sağlar.
- Geliştirme sürecini hızlandırır.

---

# 5.4 Responsive Tasarım

Uygulama farklı ekran boyutlarına uyum sağlayacak şekilde tasarlanmaktadır.

Dikkat edilen noktalar:

- Flexible layout kullanımı
- Dengeli spacing
- Farklı ekran oranlarına uyumluluk

---

# 6. Mevcut Durum ve MVP İlerlemesi

Proje geliştirme süreci, güvenli ve ölçeklenebilir authentication altyapısı oluşturma hedefiyle MVP yaklaşımı üzerinden ilerlemektedir.

---

## ✅ Tamamlanan Çalışmalar

- Flutter proje kurulumu
- Kurumsal klasör mimarisi
- Riverpod entegrasyonu
- Dio altyapısı
- Flutter Secure Storage kurulumu
- Routing sistemi
- Material 3 tema yapısı
- UI component altyapısı
- Login ekranı geliştirilmesi

---

## 🚧 Geliştirme Aşamasında

- Register ekranı
- Form validasyonları
- Kullanıcı oturum yönetimi

---

## 📌 MVP Hedefi

- Kullanıcı kayıt ve giriş işlemlerinin tamamlanması
- Backend entegrasyonu
- Token tabanlı authentication akışının tamamlanması
- Modern kullanıcı deneyimi sunulması

---

# 7. Backend Entegrasyon Notları

Mobil uygulama, backend REST API servisleri ile entegre çalışacak şekilde hazırlanmıştır.

Mobil tarafta oluşturulan yapılar:

- Dio API iletişim altyapısı
- Merkezi network yönetimi
- Repository yapısı
- Model katmanı
- Secure Storage altyapısı

UI katmanı doğrudan API işlemleri gerçekleştirmez. Veri akışı katmanlı mimari üzerinden yönetilir.

---

# 8. Uygulamayı Çalıştırma

## 8.1 Paketleri Yükleme

```bash
flutter pub get
```

---

## 8.2 Uygulamayı Başlatma

```bash
flutter run
```

---

# 9. Ekip

Bu proje, **VBT Staj Programı** kapsamında iki kişilik ekip tarafından geliştirilmektedir.

| İsim | Rol | Sorumluluk |
|-|-|-|
| Hanife İnci Kösem | Mobile Developer | Flutter geliştirme, UI/UX tasarımı, mobil mimari |
| Alper Bilgin | Backend Developer | Spring Boot API geliştirme ve backend servisleri |

---

Proje geliştirme sürecinde sürdürülebilir yazılım geliştirme prensipleri ve kurumsal proje standartları uygulanmaktadır.
Kod her değiştiğinde bu dosyayı da güncel tutmaya çalışacağız.