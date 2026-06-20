import 'package:uts_1123150074/core/constants/api_constants.dart';
import 'package:uts_1123150074/core/services/dio_client.dart';
import 'package:uts_1123150074/features/order/data/models/order_model.dart';
import 'package:uts_1123150074/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {

  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {

    final response = await DioClient.instance.post(
      ApiConstants.checkout, // POST /v1/orders/checkout
      data: {
        'shipping_address': shippingAddress,
        'notes': notes ?? '',
        'payment_method': paymentMethod,
      },
    );

    final data = response.data['data'];
    print('Checkout API Response Data: $data');

    if (data == null) {
      throw Exception('Checkout gagal: data kosong');
    }

    return OrderModel.fromJson(
      data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<OrderModel>> getMyOrders({
    int page = 1,
    int limit = 10,
  }) async {

    final response = await DioClient.instance.get(
      ApiConstants.orders,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final List<dynamic> data =
        response.data['data'] as List<dynamic>? ?? [];

    return data
        .map(
          (e) => OrderModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<OrderModel> getOrderDetail(int id) async {
  final response = await DioClient.instance.get(
    '${ApiConstants.orders}/$id',
  );

  final data = response.data['data'];

  if (data == null) {
    throw Exception('Order tidak ditemukan');
  }

  return OrderModel.fromJson(
    data as Map<String, dynamic>,
  );
}
}