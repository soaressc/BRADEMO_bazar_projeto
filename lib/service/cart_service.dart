import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart_item.dart';
import 'package:myapp/service/cart_item_service.dart';

class CartService {
  final CollectionReference<Cart> cartsRef = FirebaseFirestore.instance
      .collection('carts')
      .withConverter<Cart>(
        fromFirestore: (snap, _) => Cart.fromJson(snap.data()!),
        toFirestore: (cart, _) => cart.toJson(),
      );

  Future<void> createCart(Cart cart) async {
    try {
      await cartsRef.doc(cart.id).set(cart);
    } catch (e) {
      print("Erro ao criar carrinho: $e");
      rethrow;
    }
  }

  Future<Cart?> getCart(String id) async {
    try {
      final doc = await cartsRef.doc(id).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print("Erro ao buscar carrinho: $e");
      return null;
    }
  }

  Future<Cart?> getCartByUserId(String userId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(userId)
              .get();
      if (doc.exists) {
        return Cart.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print("Erro ao buscar carrinho pelo userId: $e");
      return null;
    }
  }

  Future<Cart?> getCartWithItems(String userId) async {
    try {
      final query =
          await FirebaseFirestore.instance
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

  Future<void> updateCart(Cart cart) async {
    try {
      await cartsRef.doc(cart.id).update(cart.toJson());
    } catch (e) {
      print("Erro ao atualizar carrinho: $e");
      rethrow;
    }
  }

  Future<void> deleteCart(String id) async {
    try {
      await cartsRef.doc(id).delete();
    } catch (e) {
      print("Erro ao excluir carrinho: $e");
      rethrow;
    }
  }

  Future<void> updateItemQuantity(
    String cartId,
    String itemId,
    int quantity,
  ) async {
    try {
      final itemService = CartItemService();
      final item = await itemService.getItemById(cartId, itemId);
      if (item != null) {
        final updatedItem = item.copyWith(quantity: quantity);
        await itemService.updateItem(cartId, updatedItem);
      }
    } catch (e) {
      print("Erro ao atualizar quantidade do item: $e");
      rethrow;
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
      final booksSnapshot =
          await FirebaseFirestore.instance
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
