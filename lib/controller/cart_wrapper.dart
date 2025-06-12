import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/cart_empty_screen.dart';
import '../service/cart_service.dart';

class CartWrapper extends StatefulWidget {
  const CartWrapper({super.key});

  @override
  State<CartWrapper> createState() => _CartWrapperState();
}

class _CartWrapperState extends State<CartWrapper> {
  bool _loading = true;
  bool _hasItems = false;

  @override
  void initState() {
    super.initState();
    _checkCart();
  }

  Future<void> _checkCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.isAnonymous) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/signup');
        }
        return;
      }

      final cartService = CartService();
      final cart = await cartService.getCartWithItems(user.uid);

      setState(() {
        _hasItems = cart != null && cart.itens.isNotEmpty;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint("Erro ao verificar carrinho: $e");
      debugPrintStack(stackTrace: st);
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _hasItems ? const CartScreen() : const CartEmptyScreen();
  }
}
