import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/cart.dart';

class CartRepository {
  final cartsRef = FirebaseFirestore.instance.collection('carts');

  Future<DocumentSnapshot> getCartDocByUserId(String userId) async {
    return await cartsRef.doc(userId).get();
  }

  Future<void> createCart(Cart cart) async {
    await cartsRef.doc(cart.id).set(cart.toJson());
  }

  Future<void> updateCart(Cart cart) async {
    await cartsRef.doc(cart.id).update(cart.toJson());
  }

  Future<void> deleteCart(String id) async {
    await cartsRef.doc(id).delete();
  }

  Future<QuerySnapshot> getCartsByUser(String userId) async {
    return await cartsRef.where('userId', isEqualTo: userId).limit(1).get();
  }
}
