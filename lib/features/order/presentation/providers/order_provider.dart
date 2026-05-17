import 'package:flutter/material.dart';
import 'package:uts_1123150074/features/order/data/models/order_model.dart';
import 'package:uts_1123150074/features/order/data/repositories/order_repository_impl.dart';
import 'package:uts_1123150074/features/order/domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  OrderStatus _checkoutStatus = OrderStatus.initial;
  OrderModel? _lastOrder;
  List<OrderModel> _orders = [];
  String? _error;

  // GETTER
  OrderStatus get checkoutStatus => _checkoutStatus;
  OrderModel? get lastOrder => _lastOrder;
  List<OrderModel> get orders => _orders;
  String? get error => _error;

  // LOADING STATE
  void _setLoading() {
    _checkoutStatus = OrderStatus.loading;
    _error = null;
    notifyListeners();
  }

  // ERROR STATE
  void _setError(String message) {
    _checkoutStatus = OrderStatus.error;
    _error = message;
    notifyListeners();
  }

  // CHECKOUT
  Future<bool> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _setLoading();

    try {
      _lastOrder = await _repository.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
        paymentMethod: paymentMethod,
      );

      _checkoutStatus = OrderStatus.success;
      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }
}