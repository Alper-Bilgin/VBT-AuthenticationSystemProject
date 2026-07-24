# Maestro E2E Testleri

Bu klasör, Flutter mobil uygulamasının kullanıcı akışlarını doğrulamak amacıyla hazırlanan **uçtan uca (End-to-End / E2E) test senaryolarını** içerir.

Maestro kullanılarak geliştirilen bu testler, gerçek kullanıcı etkileşimlerini simüle eder ve uygulamanın kritik fonksiyonlarının beklenen şekilde çalıştığını doğrulamayı amaçlar.

## Test Yapısı

Her test senaryosu, uygulamadaki belirli bir kullanıcı akışını temsil eden `.yaml` uzantılı dosyalar içerisinde tanımlanır.

Test akışları:

- Uygulamanın açılması
- Kullanıcı etkileşimlerinin gerçekleştirilmesi
- Beklenen ekran ve durum kontrollerinin yapılması

adımlarını otomatik olarak gerçekleştirir.

## Mevcut Test Akışları

| Test Dosyası | Açıklama |
|-------------|----------|
| `login.yaml` | Kullanıcının giriş yapma sürecini, form alanlarının doldurulmasını ve başarılı kimlik doğrulama sonrası uygulama akışını doğrular. |

## Testleri Çalıştırma

Maestro testlerini çalıştırmadan önce:

- Flutter uygulamasının çalışır durumda olması,
- Android emülatör veya fiziksel cihaz bağlantısının bulunması,
- Maestro CLI aracının kurulu olması

gerekmektedir.

Belirli bir test akışını çalıştırmak için:

```bash
maestro test .maestro/login.yaml