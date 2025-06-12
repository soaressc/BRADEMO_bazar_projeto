import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class CartItemService {
  // Método privado para acessar a coleção de itens do carrinho
  CollectionReference<CartItem> _cartItemRef(String cartId) {
    return FirebaseFirestore.instance
        .collection('carts')
        .doc(cartId)
        .collection('cart-items')
        .withConverter<CartItem>(
          fromFirestore: (snapshot, _) => CartItem.fromJson(snapshot.data()!),
          toFirestore: (item, _) => item.toJson(),
        );
  }

  // Adiciona um item ao carrinho
  Future<void> addItem(String cartId, CartItem item) async {
    try {
      final cartItemRef = _cartItemRef(cartId);

      if (item.id.isEmpty) {
        // Gerar ID automaticamente se estiver vazio
        final docRef = cartItemRef.doc();
        final newItem = item.copyWith(id: docRef.id);
        await docRef.set(newItem);
      } else {
        final doc = await cartItemRef.doc(item.id).get();
        if (!doc.exists) {
          await cartItemRef.doc(item.id).set(item);
        } else {
          await updateItem(cartId, item);
        }
      }
    } catch (e) {
      print("Erro ao adicionar/atualizar item: $e");
      rethrow;
    }
  }

  // Atualiza um item existente no carrinho
  Future<void> updateItem(String cartId, CartItem item) async {
    try {
      final doc = await _cartItemRef(cartId).doc(item.id).get();
      if (doc.exists) {
        // Se o item existir, realiza a atualização
        await _cartItemRef(cartId).doc(item.id).update(item.toJson());
      } else {
        // Se o item não existir, você pode adicionar o item aqui (opcional)
        await addItem(cartId, item);
      }
    } catch (e) {
      print("Erro ao atualizar item: $e");
      rethrow;
    }
  }

  // Obtém um item específico pelo ID
  Future<CartItem?> getItemById(String cartId, String itemId) async {
    try {
      final doc = await _cartItemRef(cartId).doc(itemId).get();
      return doc.exists ? doc.data() : null; // Verifica se o item existe
    } catch (e) {
      print("Erro ao buscar item: $e");
      return null;
    }
  }

  // Obtém todos os itens de um carrinho
  Future<List<CartItem>> getItems(String cartId) async {
    try {
      final snapshot = await _cartItemRef(cartId).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Erro ao buscar itens do carrinho: $e");
      return [];
    }
  }

  // Exclui um item do carrinho
  Future<void> deleteItem(String cartId, String itemId) async {
    try {
      final doc = await _cartItemRef(cartId).doc(itemId).get();
      if (doc.exists) {
        await _cartItemRef(cartId).doc(itemId).delete();
      } else {
        print("Item não encontrado para exclusão.");
      }
    } catch (e) {
      print("Erro ao excluir item: $e");
      rethrow;
    }
  }

  // Remover todos os itens do carrinho (caso precise dessa funcionalidade)
  Future<void> clearCart(String cartId) async {
    try {
      final items = await getItems(cartId);
      for (var item in items) {
        await deleteItem(cartId, item.id);
      }
    } catch (e) {
      print("Erro ao limpar o carrinho: $e");
      rethrow;
    }
  }
}
