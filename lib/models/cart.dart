import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/cart_item.dart';

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    this.items = const [],
  });

  double get total => items.fold(0.0, (sum, item) => sum + item.subtotal);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
    };
  }

  factory Cart.fromDocument(DocumentSnapshot doc, {List<CartItem> items = const []}) {
    final data = doc.data() as Map<String, dynamic>;
    return Cart(
      id: doc.id,
      userId: data['userId'],
      items: items,
    );
  }

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
    );
  }
}
