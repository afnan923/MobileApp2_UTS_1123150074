import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uts_1123150074/features/order/data/models/order_model.dart';
import 'package:uts_1123150074/features/order/data/repositories/order_repository_impl.dart';
import 'package:uts_1123150074/features/order/domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }

// PAYMENT STATUS
enum PaymentCheckStatus { idle, checking, paid, failed }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  // ORDER STATUS
  OrderStatus _checkoutStatus = OrderStatus.initial;
  OrderStatus _orderStatus = OrderStatus.initial;

  // PAYMENT STATUS
  PaymentCheckStatus _paymentCheckStatus = PaymentCheckStatus.idle;

  Timer? _paymentPollingTimer;

  // DATA
  OrderModel? _lastOrder;
  List<OrderModel> _orders = [];
  String? _error;

  // GETTER
  OrderStatus get checkoutStatus => _checkoutStatus;

  OrderStatus get orderStatus => _orderStatus;

  // PAYMENT GETTER
  PaymentCheckStatus get paymentCheckStatus => _paymentCheckStatus;

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

  // FETCH MY ORDERS
  Future<void> fetchMyOrders() async {
    _orderStatus = OrderStatus.loading;
    _error = null;

    notifyListeners();

    try {
      _orders = await _repository.getMyOrders();

      _orderStatus = OrderStatus.success;
    } catch (e) {
      _error = e.toString();
      _orderStatus = OrderStatus.error;
    }

    notifyListeners();
  }

  // CHECK PAYMENT STATUS
  Future<void> checkPaymentStatus(int orderId) async {
    _paymentCheckStatus = PaymentCheckStatus.checking;

    notifyListeners();

    try {
      // simulasi API check payment
      await Future.delayed(const Duration(seconds: 2));

      // TODO:
      // ganti dengan API asli
      // contoh:
      // final isPaid =
      //    await _repository.checkPayment(orderId);

      bool isPaid = DateTime.now().second % 2 == 0;

      if (isPaid) {
        _paymentCheckStatus = PaymentCheckStatus.paid;
      } else {
        _paymentCheckStatus = PaymentCheckStatus.idle;
      }
    } catch (e) {
      _paymentCheckStatus = PaymentCheckStatus.failed;

      _error = e.toString();
    }

    notifyListeners();
  }

  // START POLLING
  void startPaymentPolling(int orderId) {
    stopPaymentPolling();

    _paymentPollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      checkPaymentStatus(orderId);
    });
  }

  // STOP POLLING
  void stopPaymentPolling() {
    _paymentPollingTimer?.cancel();
    _paymentPollingTimer = null;
  }

  @override
  void dispose() {
    stopPaymentPolling();
    super.dispose();
  }
}
