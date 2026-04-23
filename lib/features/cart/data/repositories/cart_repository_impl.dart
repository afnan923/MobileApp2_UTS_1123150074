import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;

  CartRepositoryImpl(this.remote);

  @override
  Future<List<CartItemEntity>> getCart() async {
    return await remote.getCart();
  }

  @override
  Future<void> addToCart(int productId, int quantity) {
    return remote.addToCart(productId, quantity);
  }

  @override
  Future<void> updateCart(int id, int quantity) {
    return remote.updateCart(id, quantity);
  }

  @override
  Future<void> deleteItem(int id) {
    return remote.deleteItem(id);
  }

  @override
  Future<void> clearCart() {
    return remote.clearCart();
  }
}