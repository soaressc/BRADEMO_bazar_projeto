class CartItem {
  final String id;
  final String cartId;
  final String bookId;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.cartId,
    required this.bookId,
    required this.unitPrice,
    required this.quantity,
  });

  double get subtotal => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      cartId: json['cartId'] ?? '',
      bookId: json['bookId'] ?? '',
      unitPrice:
          (json['unitPrice'] != null)
              ? (json['unitPrice'] as num).toDouble()
              : 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'cartId': cartId, 'bookId': bookId, 'quantity': quantity};
  }

  CartItem copyWith({
    String? id,
    String? cartId,
    String? bookId,
    double? unitPrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      bookId: bookId ?? this.bookId,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
