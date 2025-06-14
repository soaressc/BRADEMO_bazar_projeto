import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/models/cart_item.dart';
import 'package:myapp/service/cart_item_service.dart';
import 'package:myapp/service/cart_service.dart';

class CartController {
  // Create an instance of CartService
  final CartService _cartService =
      CartService(); // Use _cartService instead of _service
  final CartItemService _itemService = CartItemService();

  Future<Cart?> loadCart(String userId) async {
    return await _cartService.getCartWithItems(
      userId,
    ); // Fix reference to _cartService
  }

  Future<void> addToCart(String userId, Book book, int quantity) async {
    final cart = await _cartService.createOrGetCart(
      userId,
    ); // Fix reference to _cartService
    final existingItem = await _itemService.getItem(cart.id, book.id);

    if (existingItem != null) {
      final updated = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      await _itemService.addOrUpdateItem(cart.id, updated);
    } else {
      final newItem = CartItem(
        id: book.id,
        cartId: cart.id,
        bookId: book.id,
        unitPrice: book.priceValue,
        quantity: quantity,
      );
      await _itemService.addOrUpdateItem(cart.id, newItem);
    }
  }

  Future<void> removeFromCart(String userId, String itemId) async {
    final cart = await _cartService.createOrGetCart(userId);
    await _cartService.removeItem(cart.id, itemId);
  }

  Future<void> updateItemQuantity(
    String userId,
    String itemId,
    int quantity,
  ) async {
    final cart = await _cartService.createOrGetCart(userId);
    await _cartService.updateItemQuantity(cart.id, itemId, quantity);
  }

  Future<Map<String, Book>> fetchBooks(List<String> bookIds) async {
    return await _cartService.fetchBooks(bookIds);
  }
}
