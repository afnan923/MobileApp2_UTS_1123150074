import 'package:flutter/material.dart';
import 'package:uts_1123150074/features/cart/data/models/cart_model.dart';
import 'package:uts_1123150074/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:uts_1123150074/features/cart/domain/repositories/cart_repository.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
}

class CartProvider extends ChangeNotifier {
  final CartRepository _repository = CartRepositoryImpl();

  CartStatus _status = CartStatus.initial;
  CartModel? _cart;
  String? _error;
  bool _isAdding = false;

  // GETTER
  CartStatus get status => _status;
  CartModel? get cart => _cart;
  String? get error => _error;
  bool get isAdding => _isAdding;

  // Badge count
  int get itemCount => _cart?.itemCount ?? 0;

  // FETCH CART
  Future<void> fetchCart() async {
    try {
      _status = CartStatus.loading;
      notifyListeners();

      _cart = await _repository.getCart();

      _status = CartStatus.loaded;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _status = CartStatus.error;
      notifyListeners();
    }
  }

  // ADD TO CART
  Future<bool> addToCart(
    int productId,
    int quantity,
  ) async {
    try {
      _isAdding = true;
      notifyListeners();

      await _repository.addToCart(
        productId,
        quantity,
      );

      await fetchCart();

      _isAdding = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isAdding = false;
      notifyListeners();

      return false;
    }
  }

  // UPDATE ITEM
  Future<void> updateItem(
    int cartItemId,
    int quantity,
  ) async {
    try {
      await _repository.updateCartItem(
        cartItemId,
        quantity,
      );

      await fetchCart();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // REMOVE ITEM
  Future<void> removeItem(int cartItemId) async {
    try {
      await _repository.removeCartItem(cartItemId);

      await fetchCart();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // CLEAR CART
  Future<void> clearCart() async {
    try {
      await _repository.clearCart();

      // kosongkan local state
      _cart = CartModel(
        items: [],
        total: 0,
        itemCount: 0,
      );

      _status = CartStatus.loaded;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}