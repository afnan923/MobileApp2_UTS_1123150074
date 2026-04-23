import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCart();
  Future<void> addToCart(int productId, int quantity);
  Future<void> updateCart(int id, int quantity);
  Future<void> deleteItem(int id);
  Future<void> clearCart();
}