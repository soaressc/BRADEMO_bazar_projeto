import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class Cart {
  final String id;
  final String userId;
  final List<CartItem> itens;

  Cart({required this.id, required this.userId, required this.itens});

  double get total => itens.fold(0.0, (sum, item) => sum + item.subtotal);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      itens:
          (json['itens'] as List<dynamic>)
              .map((item) => CartItem.fromJson(item))
              .toList(),
    );
  }

  factory Cart.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Cart(
      id: doc.id, // geralmente o ID vem do doc.id
      userId: data['userId'],
      itens:
          (data['itens'] as List<dynamic>)
              .map((item) => CartItem.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toDocument() {
    return toJson();
  }
}
