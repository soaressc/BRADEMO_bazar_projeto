// screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import './product_detail_screen.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/bottom_bar.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> itens;

  @override
  void initState() {
    super.initState();
    itens = widget.cart.itens;
  }

  void _removeItem(String id) {
    setState(() {
      itens.removeWhere((item) => item.id == id);
    });
  }

  void _updateQuantidade(String id, int novaQuantidade) {
    setState(() {
      final item = itens.firstWhere((item) => item.id == id);
      item.quantidade = novaQuantidade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Text("Order: "),
                Text("#168504", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itens.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = itens[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _openProductDetail(context, item.book),
                            child: Text(
                              item.book.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          QuantitySelector(
                            quantity: item.quantidade,
                            onAdd:
                                () => _updateQuantidade(
                                  item.id,
                                  item.quantidade + 1,
                                ),
                            onRemove: () {
                              if (item.quantidade > 1) {
                                _updateQuantidade(item.id, item.quantidade - 1);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.book.price,
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
                );
              },
            ),
          ),
          // Total + Checkout
          Container(
            color: Colors.deepPurple,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Total:", style: TextStyle(color: Colors.white)),
                    const Spacer(),
                    Text(
                      "R\$ ${widget.cart.total.toStringAsFixed(2)}",
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
                    // TODO: Implementar fluxo de checkout
                  },
                  child: const Text("Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: 2, // índice da aba "Cart"
        onTap: (index) {
          // Troca de telas (você pode usar Navigator ou outro método de navegação aqui)
          print('Tapped on index $index');
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
    );
  }
}
