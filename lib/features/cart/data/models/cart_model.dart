import '../../domain/entities/cart_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.price,
    required super.quantity,
    required super.imageUrl, 
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];

    return CartItemModel(
      id: json['ID'], 
      productId: json['product_id'],
      productName: product['name'],
      price: (product['price'] as num).toDouble(),
      quantity: json['quantity'],
      imageUrl: product['image_url'],
    );
  }
}