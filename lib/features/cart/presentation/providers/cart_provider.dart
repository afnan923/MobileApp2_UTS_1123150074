import 'package:flutter/material.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository repository;

  CartProvider(this.repository);

  bool _isLoading = false;
  List<CartItemEntity> _items = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<CartItemEntity> get items => _items;
  String? get error => _error;

  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  Future<void> fetchCart() async {
    _setLoading();
    try {
      _items = await repository.getCart();
    } catch (e) {
      _error = 'Gagal ambil cart';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(int productId, int qty) async {
    await repository.addToCart(productId, qty);
    await fetchCart();
  }

  Future<void> updateItem(int id, int qty) async {
    await repository.updateCart(id, qty);
    await fetchCart();
  }

  Future<void> removeItem(int id) async {
    await repository.deleteItem(id);
    await fetchCart();
  }

  Future<void> clearCart() async {
    await repository.clearCart();
    _items.clear();
    notifyListeners();
  }

  void _setLoading() {
    _isLoading = true;
    _error = null;
    notifyListeners();
  }
}