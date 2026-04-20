class CartItemEntity {
  final int id;
  final int productId;
  final String productName;
  final int price;
  final int quantity;

  CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}