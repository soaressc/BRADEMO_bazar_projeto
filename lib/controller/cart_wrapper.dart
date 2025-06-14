import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/screens/cart_screen.dart';
import 'package:myapp/service/cart_service.dart';
import 'package:myapp/widgets/bottom_bar.dart';
import 'package:myapp/widgets/cart_empty_screen.dart';

class CartWrapper extends StatefulWidget {
  const CartWrapper({super.key});

  @override
  State<CartWrapper> createState() => _CartWrapperState();
}

class _CartWrapperState extends State<CartWrapper> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/category');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

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

        if (cart == null || cart.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Carrinho"), centerTitle: true),
            body: const CartEmptyScreen(),
            bottomNavigationBar: BottomBar(
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }

        return const CartScreen();
      },
    );
  }
}
