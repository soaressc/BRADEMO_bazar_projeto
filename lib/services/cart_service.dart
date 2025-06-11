import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart.dart';

class CartService {
  final CollectionReference<Cart> cartsRef = FirebaseFirestore.instance
      .collection('carts')
      .withConverter<Cart>(
        fromFirestore: (snap, _) => Cart.fromMap(snap.data()!),
        toFirestore: (cart, _) => cart.toMap(),
      );

  Future<void> createCart(Cart cart) => cartsRef.doc(cart.id).set(cart);

  Future<Cart?> getCart(String id) async {
    final doc = await cartsRef.doc(id).get();
    return doc.data();
  }

  Future<void> updateCart(Cart cart) =>
      cartsRef.doc(cart.id).update(cart.toMap());

  Future<void> deleteCart(String id) => cartsRef.doc(id).delete();
}
