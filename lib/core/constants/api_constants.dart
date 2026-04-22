class ApiConstants {
  static const String baseUrl = 'http://192.168.1.12:8080/v1';

  // Auth
  static const String verifyToken = '/auth/verify-token';

  // Products
  static const String products = '/products';

  // Cart
  static const String cart = '/cart';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}