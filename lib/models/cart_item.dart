import 'book.dart';

class CartItem {
  final String id;
  final String cartId;
  final Book book;
  int quantidade;

  CartItem({
    required this.id,
    required this.cartId,
    required this.book,
    required this.quantidade,
  });

  double get subtotal => book.priceValue * quantidade;
}