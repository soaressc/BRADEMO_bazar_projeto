import 'cart_item.dart';

class Cart {
  final String id;
  final String usuarioId;
  final List<CartItem> itens;

  Cart({
    required this.id,
    required this.usuarioId,
    required this.itens,
  });

  double get total => itens.fold(0.0, (sum, item) => sum + item.subtotal);

  static fromMap(Map<String, dynamic> map) {}

  toMap() {}
}