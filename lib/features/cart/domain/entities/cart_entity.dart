class CartItemEntity {
  final int id;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}