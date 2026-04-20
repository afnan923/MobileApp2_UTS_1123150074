class ApiConstants {
  static const String baseUrl = 'http://172.20.10.6:8080/v1';

  // Auth
  static const String verifyToken = '/auth/verify-token';

  // Products
  static const String products = '/products';

  // Cart
  static const String cart = '/cart';

  // Orders
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';

  // Admin Orders
  static const String adminOrders = '/admin/orders';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}