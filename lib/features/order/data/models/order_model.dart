class OrderItemModel {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = json['quantity'] as int? ?? 0;

    return OrderItemModel(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      price: price,
      quantity: quantity,
      subtotal: (json['subtotal'] as num?)?.toDouble() ??
          (price * quantity),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

class OrderModel {
  final int id;
  final double totalAmount;
  final String status;
  // pending | processing | shipped | delivered | cancelled

  final String shippingAddress;
  final String notes;

  final String paymentMethod;
  // gopay | bank_transfer | virtual_account

  // TAMBAHKAN INI
  final String? gopayDeeplink;
  final String? vaNumber;

  final List<OrderItemModel> items;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.notes,
    required this.paymentMethod,

    // TAMBAHKAN
    this.gopayDeeplink,
    this.vaNumber,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => OrderItemModel.fromJson(e))
        .toList();

    return OrderModel(
      id: json['id'] as int? ?? 0,
      totalAmount:
          (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      shippingAddress:
          json['shipping_address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      paymentMethod:
          json['payment_method'] as String? ?? '',
          // TAMBAHKAN
      gopayDeeplink:
          json['gopay_deeplink'] as String?,
      vaNumber:
          json['va_number'] as String?,
      items: items,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'notes': notes,
      'payment_method': paymentMethod,
      // TAMBAHKAN
      'gopay_deeplink': gopayDeeplink,
      'va_number': vaNumber,
      'items': items.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
    };
  }
}