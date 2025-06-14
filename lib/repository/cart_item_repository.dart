import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class CartItemRepository {
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

  Future<void> createOrUpdate(String cartId, CartItem item) async {
    final ref = _cartItemRef(cartId).doc(item.id);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set(item);
    } else {
      await ref.update(item.toJson());
    }
  }

  Future<void> delete(String cartId, String itemId) async {
    await _cartItemRef(cartId).doc(itemId).delete();
  }

  Future<CartItem?> getById(String cartId, String itemId) async {
    final doc = await _cartItemRef(cartId).doc(itemId).get();
    return doc.exists ? doc.data() : null;
  }

  Future<List<CartItem>> getAll(String cartId) async {
    final snapshot = await _cartItemRef(cartId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> clearCart(String cartId) async {
    final items = await getAll(cartId);
    for (final item in items) {
      await delete(cartId, item.id);
    }
  }
}
