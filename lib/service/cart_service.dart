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

  // Método para criar um novo carrinho
  Future<void> createCart(Cart cart) async {
    try {
      await cartsRef.doc(cart.id).set(cart);
    } catch (e) {
      print("Erro ao criar carrinho: $e");
      rethrow;
    }
  }

  // Obter carrinho com base no ID
  Future<Cart?> getCart(String id) async {
    try {
      final doc = await cartsRef.doc(id).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print("Erro ao buscar carrinho: $e");
      return null;
    }
  }

  // Obter o carrinho de um usuário (usando userId)
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

  // Obter carrinho com itens
  Future<Cart?> getCartWithItems(String userId) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(userId)
              .get();
      if (!doc.exists) return null;

      final cart = Cart.fromDocument(doc);
      final itemService = CartItemService();
      final items = await itemService.getItems(cart.id);

      return Cart(id: cart.id, userId: cart.userId, itens: items);
    } catch (e) {
      print("Erro ao buscar carrinho com itens: $e");
      return null;
    }
  }

  // Atualizar carrinho existente
  Future<void> updateCart(Cart cart) async {
    try {
      await cartsRef.doc(cart.id).update(cart.toJson());
    } catch (e) {
      print("Erro ao atualizar carrinho: $e");
      rethrow;
    }
  }

  // Deletar carrinho
  Future<void> deleteCart(String id) async {
    try {
      await cartsRef.doc(id).delete();
    } catch (e) {
      print("Erro ao excluir carrinho: $e");
      rethrow;
    }
  }

  // Atualizar quantidade de um item específico no carrinho
  Future<void> updateItemQuantity(
    String cartId,
    String itemId,
    int quantity,
  ) async {
    try {
      final itemService = CartItemService();
      final item = await itemService.getItemById(
        cartId,
        itemId,
      ); // Mudança aqui
      if (item != null) {
        final updatedItem = item.copyWith(quantity: quantity);
        await itemService.updateItem(cartId, updatedItem); // Usando updateItem
      }
    } catch (e) {
      print("Erro ao atualizar quantidade do item: $e");
      rethrow;
    }
  }

  // Remover um item específico do carrinho
  Future<void> removeItem(String cartId, String itemId) async {
    try {
      final itemService = CartItemService();
      await itemService.deleteItem(cartId, itemId); // Mudança aqui
    } catch (e) {
      print("Erro ao remover item do carrinho: $e");
      rethrow;
    }
  }

  // Método para buscar os livros no Firestore e mapear para um formato adequado
  Future<Map<String, Book>> fetchBooks(List<String> bookIds) async {
    try {
      final booksSnapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .where(FieldPath.documentId, whereIn: bookIds)
              .get();

      return {
        for (var doc in booksSnapshot.docs) doc.id: Book.fromMap(doc.data()),
      };
    } catch (e) {
      print("Erro ao buscar livros: $e");
      return {};
    }
  }
}
