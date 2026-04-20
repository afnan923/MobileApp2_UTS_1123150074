abstract class CartRepository {
  Future<List<dynamic>> getCart();

  Future<void> addToCart({
    required int productId,
    required int quantity,
  });

  Future<void> updateCartItem({
    required int id,
    required int quantity,
  });

  Future<void> removeCartItem(int id);

  Future<void> clearCart();
}