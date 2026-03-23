class AppConstants {
  AppConstants._();

  static const String appName    = 'Jagdish Foods';
  static const String appTagline = "Vadodara's Taste Since 1945";
  static const String baseUrl    = 'https://api.jagdishfoods.com/v1';

  static const String kAuthToken       = 'auth_token';
  static const String kCartBox         = 'cart_box';
  static const String kWishlistBox     = 'wishlist_box';
  static const String kOnboarded       = 'is_onboarded';

  static const int    otpLength        = 6;
  static const int    otpResendSeconds = 30;
  static const int    maxCartQty       = 10;
  static const double freeDeliveryAt   = 299.0;
  static const double deliveryFee      = 49.0;

  static const List<Map<String, dynamic>> categories = [
    {'id': '1', 'name': 'Bhakharwadi', 'emoji': '🥐', 'color': 0xFFFFF3CD},
    {'id': '2', 'name': 'Chevdo',      'emoji': '🌾', 'color': 0xFFD4EDFF},
    {'id': '3', 'name': 'Sev',         'emoji': '🪢', 'color': 0xFFD4F5C4},
    {'id': '4', 'name': 'Khakhra',     'emoji': '🫓', 'color': 0xFFFFE0D0},
    {'id': '5', 'name': 'Sweets',      'emoji': '🍬', 'color': 0xFFF3E8FF},
    {'id': '6', 'name': 'Gift Packs',  'emoji': '🎁', 'color': 0xFFFFF3CD},
  ];
}
