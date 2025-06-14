import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/models/cart_item.dart';
import 'package:myapp/controller/cart_controller.dart';
import 'package:myapp/widgets/cart_empty_screen.dart';
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
  final CartController _controller = CartController();

  String? userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    if (userId != null) {
      _futureCart = _controller.loadCart(userId!);
    }
  }

  void _refreshCart() {
    if (userId != null) {
      setState(() {
        _futureCart = _controller.loadCart(userId!);
      });
    }
  }

  void _removeItem(String cartItemId) async {
    if (userId != null) {
      await _controller.removeFromCart(userId!, cartItemId);
      _refreshCart();
    }
  }

  void _updateQuantity(String cartItemId, int newQuantity) async {
    if (userId != null) {
      await _controller.updateItemQuantity(userId!, cartItemId, newQuantity);
      _refreshCart();
    }
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (total, item) => total + (item.unitPrice * item.quantity),
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

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não autenticado")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: FutureBuilder<Cart?>(
        future: _futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const CartEmptyScreen();
          }

          final cart = snapshot.data!;
          final cartItems = cart.items;
          final bookIds = cartItems.map((item) => item.bookId).toSet().toList();

          return FutureBuilder<Map<String, Book>>(
            future: _controller.fetchBooks(bookIds),
            builder: (context, bookSnapshot) {
              if (bookSnapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (bookSnapshot.hasError ||
                  !bookSnapshot.hasData ||
                  bookSnapshot.data!.isEmpty) {
                return const CartEmptyScreen();
              }

              final bookMap = bookSnapshot.data!;

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Text("Order: "),
                        Text(
                          "#168504",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final book = bookMap[item.bookId];
                        if (book == null) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap:
                                          () =>
                                              _openProductDetail(context, book),
                                      child: Text(
                                        book.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    QuantitySelector(
                                      quantity: item.quantity,
                                      onAdd:
                                          () => _updateQuantity(
                                            item.id,
                                            item.quantity + 1,
                                          ),
                                      onRemove: () {
                                        if (item.quantity > 1) {
                                          _updateQuantity(
                                            item.id,
                                            item.quantity - 1,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'R\$ ${item.unitPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
                  Container(
                    color: Colors.deepPurple,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              "R\$ ${_calculateTotal(cartItems).toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Implement checkout logic
                          },
                          child: const Text("Checkout"),
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
}
