import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/service/cart_item_service.dart';

class CartService {
  final CollectionReference<Cart> cartsRef = FirebaseFirestore.instance
      .collection('carts')
      .withConverter<Cart>(
        fromFirestore: (snap, _) => Cart.fromJson(snap.data()!),
        toFirestore: (cart, _) => cart.toJson(),
      );

  Future<Cart?> getCartWithItems(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('carts')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final cartDoc = query.docs.first;
      final cart = Cart.fromDocument(cartDoc);
      final items = await CartItemService().getItems(cart.id);

      return cart.copyWith(items: items);
    } catch (e) {
      print("Erro ao buscar carrinho com itens: $e");
      return null;
    }
  }

  Future<void> removeItem(String cartId, String itemId) async {
    try {
      await CartItemService().deleteItem(cartId, itemId);
    } catch (e) {
      print("Erro ao remover item do carrinho: $e");
      rethrow;
    }
  }

  Future<Map<String, Book>> fetchBooks(List<String> bookIds) async {
    try {
      final booksSnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where(FieldPath.documentId, whereIn: bookIds)
          .get();

      return {
        for (var doc in booksSnapshot.docs)
          doc.id: Book.fromMap(doc.data(), id: doc.id),
      };
    } catch (e) {
      print("Erro ao buscar livros: $e");
      return {};
    }
  }
}