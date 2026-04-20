import 'package:uts_1123150074/core/constants/api_constants.dart';
import 'package:uts_1123150074/core/services/dio_client.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final dio = DioClient.instance;

  Future<List<CartItemModel>> getCart() async {
    final res = await dio.get(ApiConstants.cart);

    final List data = res.data['data'];
    return data.map((e) => CartItemModel.fromJson(e)).toList();
  }

  Future<void> addToCart(int productId, int quantity) async {
    await dio.post(
      ApiConstants.cart,
      data: {
        "product_id": productId,
        "quantity": quantity,
      },
    );
  }

  Future<void> updateCart(int id, int quantity) async {
    await dio.put(
      '${ApiConstants.cart}/$id',
      data: {"quantity": quantity},
    );
  }

  Future<void> deleteItem(int id) async {
    await dio.delete('${ApiConstants.cart}/$id');
  }

  Future<void> clearCart() async {
    await dio.delete(ApiConstants.cart);
  }
}