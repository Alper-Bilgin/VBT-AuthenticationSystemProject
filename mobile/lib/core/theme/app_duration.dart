// Uygulama içerisindeki animasyon sürelerini merkezi yönetir.
// 
// Böylece her yerde farklı duration kullanmak yerine
// tek bir tasarım dili oluşturulur.

class AppDuration {
  AppDuration._();

  /// Çok hızlı geçişler
  static const Duration fast = Duration(milliseconds: 150);


  /// Normal UI animasyonları
  /// Örn: button animasyonu, opacity değişimleri
  static const Duration normal = Duration(milliseconds: 300);


  /// Daha yumuşak geçişler
  /// Örn: ekran geçişleri, büyük animasyonlar
  static const Duration slow = Duration(milliseconds: 500);
}