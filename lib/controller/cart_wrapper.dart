import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/cart.dart';
import '../screens/cart_screen.dart';
import '../screens/cart_empty_screen.dart';
import '../service/cart_service.dart';

class CartWrapper extends StatelessWidget {
  const CartWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.isAnonymous) {
      Future.microtask(
        () => Navigator.pushReplacementNamed(context, '/signup'),
      );
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return FutureBuilder<Cart?>(
      future: CartService().getCartWithItems(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Erro ao carregar carrinho")),
          );
        }

        final cart = snapshot.data;
        print("Itens do carrinho: ${cart?.items.map((e) => e.bookId)}");

        if (cart == null || cart.items.isEmpty) {
          return const CartEmptyScreen();
        }

        return const CartScreen();
      },
    );
  }
}
