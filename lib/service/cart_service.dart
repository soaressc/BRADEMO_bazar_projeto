import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/repository/cart_repository.dart';
import 'package:myapp/service/cart_item_service.dart';

class CartService {
  final CartRepository _repository = CartRepository();
  final CartItemService _itemService = CartItemService();

  Future<Cart?> getCartWithItems(String userId) async {
    final snapshot = await _repository.getCartsByUser(userId);
    if (snapshot.docs.isEmpty) return null;

    final cartDoc = snapshot.docs.first;
    final cart = Cart.fromDocument(cartDoc);
    final items = await _itemService.getItems(cart.id);
    return cart.copyWith(items: items);
  }

  Future<Cart> createOrGetCart(String userId) async {
    final snapshot = await _repository.getCartDocByUserId(userId);
    if (snapshot.exists) {
      final cart = Cart.fromDocument(snapshot);
      return cart;
    }

    final cart = Cart(id: userId, userId: userId);
    await _repository.createCart(cart);
    return cart;
  }

  Future<void> removeItem(String cartId, String itemId) async {
    await _itemService.deleteItem(cartId, itemId);
  }

  Future<void> updateItemQuantity(
    String cartId,
    String itemId,
    int quantity,
  ) async {
    final item = await _itemService.getItem(cartId, itemId);
    if (item != null) {
      final updated = item.copyWith(quantity: quantity);
      await _itemService.addOrUpdateItem(cartId, updated);
    }
  }

  Future<Map<String, Book>> fetchBooks(List<String> bookIds) async {
    final booksSnapshot =
        await FirebaseFirestore.instance
            .collection('books')
            .where(FieldPath.documentId, whereIn: bookIds)
            .get();

    return {
      for (var doc in booksSnapshot.docs)
        doc.id: Book.fromMap(doc.data(), id: doc.id),
    };
  }
}
