import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart_item.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/service/cart_service.dart';
import 'package:myapp/service/cart_item_service.dart';
import 'package:myapp/widgets/quantity_selector.dart';
import 'package:myapp/widgets/bottom_bar.dart';
import 'package:myapp/screens/product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart?> _futureCart;
  final CartService _cartService = CartService();
  final CartItemService _cartItemService = CartItemService();

  String? userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    if (userId != null) {
      _futureCart = _cartService.getCartWithItems(userId!);
    }
  }

  void _refreshCart() {
    if (userId != null) {
      setState(() {
        _futureCart = _cartService.getCartWithItems(userId!);
      });
    }
  }

  void _removeItem(String cartItemId) async {
    final cart = await _futureCart;
    if (cart != null) {
      await _cartItemService.deleteItem(cart.id, cartItemId);
      _refreshCart();
    }
  }

  void _updateQuantity(String cartItemId, int newQuantity) async {
    final cart = await _futureCart;
    if (cart != null) {
      final item = cart.itens.firstWhere((i) => i.id == cartItemId);
      final updatedItem = item.copyWith(quantity: newQuantity);
      await _cartItemService.updateItem(cart.id, updatedItem);
      _refreshCart();
    }
  }

  double _calculateTotal(List<CartItem> items, Map<String, Book> bookMap) {
    return items.fold(0.0, (total, item) {
      final book = bookMap[item.bookId];
      final price = book?.priceValue ?? 0.0;
      return total + (price * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não autenticado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart"), centerTitle: true),
      body: FutureBuilder<Cart?>(
        future: _futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Erro ao carregar carrinho"));
          }

          final cart = snapshot.data!;
          final cartItems = cart.itens;
          final bookIds = cartItems.map((item) => item.bookId).toSet().toList();

          return FutureBuilder<Map<String, Book>>(
            future: _cartService.fetchBooks(bookIds),
            builder: (context, bookSnapshot) {
              if (bookSnapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (bookSnapshot.hasError || !bookSnapshot.hasData) {
                return const Center(child: Text("Erro ao carregar livros"));
              }

              final bookMap = bookSnapshot.data!;

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final book = bookMap[item.bookId];
                        if (book == null) return const SizedBox.shrink();

                        return ListTile(
                          title: GestureDetector(
                            onTap: () => _openProductDetail(context, book),
                            child: Text(book.title),
                          ),
                          subtitle: QuantitySelector(
                            quantity: item.quantity,
                            onAdd:
                                () =>
                                    _updateQuantity(item.id, item.quantity + 1),
                            onRemove: () {
                              if (item.quantity > 1) {
                                _updateQuantity(item.id, item.quantity - 1);
                              }
                            },
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(book.price),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeItem(item.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text("Total:"),
                        const Spacer(),
                        Text(
                          "R\$ ${_calculateTotal(cartItems, bookMap).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/category');
          if (index == 3) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  void _openProductDetail(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailScreen(book: book),
    ).then((_) => _refreshCart());
  }
}
