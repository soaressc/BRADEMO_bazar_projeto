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
    final width = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
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
                // Handle
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

                // Image
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

                // Title + Favorite
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.book.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FavoriteButton(isFavorite: isFavorite, onTap: _toggleFavorite),
                  ],
                ),

                const SizedBox(height: 4),

                // Store
                Text(
                  widget.book.store,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: scheme.secondary,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  widget.book.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),

                const SizedBox(height: 24),

                // Review section
                Text(
                  'Review',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                RatingStars(
                  rating: widget.book.rating,
                  reviewCount: widget.book.reviewCount,
                ),

                const SizedBox(height: 24),

                // Quantity and Price
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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                ActionButtons(
                  primaryLabel: 'Continue shopping',
                  onPrimaryPressed: () => Navigator.pop(context),
                  secondaryLabel: 'View cart',
                  onSecondaryPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
