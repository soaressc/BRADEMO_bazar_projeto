import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/repository/cart_repository.dart';

class CartController extends ChangeNotifier {
  final CartRepository _cartRepository = CartRepository();
  late Future<Cart?> _futureCart;
  String? userId;

  CartController() {
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    if (userId != null) {
      _futureCart = _cartRepository.getCartWithItems(userId!);
    }
  }

  Future<void> fetchCart() async {
    if (userId != null) {
      _futureCart = _cartRepository.getCartWithItems(userId!);
      notifyListeners();
    }
  }

  Future<void> removeItem(String cartItemId) async {
    final cart = await _futureCart;
    if (cart != null) {
      await _cartRepository.removeItem(cart.id, cartItemId);
      fetchCart();
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final cart = await _futureCart;
    if (cart != null) {
      final item = cart.items.firstWhere((i) => i.id == cartItemId);
      final updatedItem = item.copyWith(quantity: newQuantity);
      await _cartRepository.removeItem(cart.id, updatedItem.id);
      fetchCart();
    }
  }

  Future<Map<String, Book>> fetchBooks(List<String> bookIds) async {
    return await _cartRepository.fetchBooks(bookIds);
  }

  Future<Cart?> getCart() async {
    return await _futureCart;
  }
}
