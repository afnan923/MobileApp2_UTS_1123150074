class CartProductModel {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      // backend kadang pakai 'ID' atau 'id'
      id: json['ID'] as int? ?? json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class CartItemModel {
  final CartProductModel product;
  final int quantity;
  final double subtotal;

  CartItemModel({
    required this.product,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = CartProductModel.fromJson(
      json['product'] as Map<String, dynamic>? ?? {},
    );

    final quantity = json['quantity'] as int? ?? 0;

    // Prioritas:
    // 1. pakai subtotal dari API jika ada
    // 2. fallback hitung sendiri
    final apiSubtotal =
        (json['subtotal'] as num?)?.toDouble() ?? 0.0;

    final subtotal =
        apiSubtotal > 0 ? apiSubtotal : product.price * quantity;

    return CartItemModel(
      product: product,
      quantity: quantity,
      subtotal: subtotal,
    );
  }
}

class CartModel {
  final List<CartItemModel> items;
  final double total;

  CartModel({
    required this.items,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => CartItemModel.fromJson(e))
        .toList();

    // Selalu hitung total dari semua subtotal item
    final total = items.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );

    return CartModel(
      items: items,
      total: total,
    );
  }
}