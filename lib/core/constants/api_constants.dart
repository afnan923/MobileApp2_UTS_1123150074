class ApiConstants {
  static const String baseUrl = 'http://192.168.1.12:8080/v1';

  // Auth
  static const String verifyToken = '/auth/verify-token';

  // Products
  static const String products = '/products';

  // Cart
  static const String cart = '/cart';

  // Order endpoints
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';


  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}