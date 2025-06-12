// CartItem Service (subcollection of Cart)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/cart_item.dart';

class CartItemService {
  CollectionReference<CartItem> _cartItemRef(String cartId) {
    return FirebaseFirestore.instance
        .collection('carts')
        .doc(cartId)
        .collection('items')
        .withConverter<CartItem>(
          fromFirestore: (snap, _) => CartItem.fromJson(snap.data()!),
          toFirestore: (item, _) => item.toJson(),
        );
  }

  Future<void> addItem(String cartId, CartItem item) async {
    await _cartItemRef(cartId).doc(item.id).set(item);
  }

  Future<List<CartItem>> getItems(String cartId) async {
    final snapshot = await _cartItemRef(cartId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateItem(String cartId, CartItem item) async {
    await _cartItemRef(cartId).doc(item.id).update(item.toJson());
  }

  Future<void> deleteItem(String cartId, String itemId) async {
    await _cartItemRef(cartId).doc(itemId).delete();
  }
}
