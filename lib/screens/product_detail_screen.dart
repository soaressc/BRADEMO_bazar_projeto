import 'package:flutter/material.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/models/cart_item.dart';
import 'package:myapp/service/cart_item_service.dart';
import 'package:myapp/service/cart_service.dart';
import '../models/book.dart';
import '../widgets/favorite_button.dart';
import '../widgets/rating_stars.dart';
import '../widgets/action_buttons.dart';
import '../widgets/quantity_selector.dart';
import '../utils/session.dart';

class ProductDetailScreen extends StatefulWidget {
  final Book book;

  const ProductDetailScreen({super.key, required this.book});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;
  int quantity = 1;

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _handleAddToCart() async {
    final appUser = await Session.getCurrentAppUser();

    if (appUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não autenticado ou não encontrado!'),
        ),
      );
      return;
    }

    final cartService = CartService();
    final cartItemService = CartItemService();

    Cart? cart = await cartService.getCartByUserId(appUser.id);

    if (cart == null) {
      cart = Cart(id: appUser.id, userId: appUser.id, itens: []);
      await cartService.createCart(cart);
    }

    final String itemId = widget.book.id;
    final existingItems = await cartItemService.getItems(cart.id);
    final existingItem = existingItems.firstWhere(
      (item) => item.id == itemId,
      orElse:
          () => CartItem(
            id: '',
            cartId: '',
            bookId: '',
            unitPrice: 0.0,
            quantity: 0,
          ),
    );

    final isValidItem = existingItem.id.isNotEmpty;

    if (isValidItem) {
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      await cartItemService.updateItem(cart.id, updatedItem);
    } else {
      final newItem = CartItem(
        id: itemId,
        cartId: cart.id,
        bookId: widget.book.id,
        unitPrice: widget.book.priceValue,
        quantity: quantity,
      );
      await cartItemService.addItem(cart.id, newItem);
    }

    if (!mounted) return;

    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 100));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro adicionado ao carrinho!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.95,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.book.imageUrl,
                      width: width * 0.5,
                      height: width * 0.7,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.book.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FavoriteButton(
                      isFavorite: isFavorite,
                      onTap: _toggleFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.book.store,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.book.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Text('Review', style: Theme.of(context).textTheme.titleMedium),
                RatingStars(
                  rating: widget.book.rating,
                  reviewCount: widget.book.reviewCount,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    QuantitySelector(
                      quantity: quantity,
                      onAdd: _incrementQuantity,
                      onRemove: _decrementQuantity,
                    ),
                    const Spacer(),
                    Text(
                      widget.book.price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ActionButtons(
                  primaryLabel: 'Add to cart',
                  onPrimaryPressed: _handleAddToCart,
                  secondaryLabel: 'View cart',
                  onSecondaryPressed:
                      () => Navigator.pushNamed(context, '/cart'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
