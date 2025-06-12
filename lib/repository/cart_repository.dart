import 'package:myapp/models/cart.dart';
import 'package:myapp/models/book.dart';  // Corrigido: Agora estamos trabalhando com Book, não CartItem
import 'package:myapp/service/cart_service.dart';

class CartRepository {
  final CartService _cartService = CartService();

  Future<Cart?> getCartWithItems(String userId) {
    return _cartService.getCartWithItems(userId);
  }

  Future<void> removeItem(String cartId, String itemId) {
    return _cartService.removeItem(cartId, itemId);
  }

  Future<Map<String, Book>> fetchBooks(List<String> bookIds) {
    return _cartService.fetchBooks(bookIds);
  }
}
