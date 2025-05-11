import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/favorite_button.dart';
import '../widgets/rating_stars.dart';
import '../widgets/action_buttons.dart';
import '../widgets/quantity_selector.dart';

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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
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
                // Imagem
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.book.imageUrl,
                      height: 220,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 220),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Título + Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.book.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FavoriteButton(
                      isFavorite: isFavorite,
                      onTap: _toggleFavorite,
                    ),
                  ],
                ),

                Text(
                  widget.book.store,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scheme.secondary,
                  ),
                ),

                const SizedBox(height: 8),

                // Descrição
                Text(
                  widget.book.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),

                const SizedBox(height: 16),

                // Review
                Text("Review", style: Theme.of(context).textTheme.titleMedium),
                RatingStars(
                  rating: widget.book.rating,
                  reviewCount: widget.book.reviewCount,
                ),

                const SizedBox(height: 24),

                // Quantidade e Preço
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

                // Botões de ação
                ActionButtons(
                  primaryLabel: "Continue shopping",
                  onPrimaryPressed: () {
                    Navigator.pop(context);
                  },
                  secondaryLabel: "View cart",
                  onSecondaryPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
