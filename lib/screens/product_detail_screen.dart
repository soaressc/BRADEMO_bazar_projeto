import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/favorite_button.dart';  // Import your FavoriteButton
import '../widgets/rating_stars.dart';
import '../widgets/action_buttons.dart';  // Import ActionButtons

class ProductDetailScreen extends StatefulWidget {
  final Book book;
  final ScrollController scrollController;

  const ProductDetailScreen({
    super.key,
    required this.book,
    required this.scrollController,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;  // Local state to track if the product is marked as favorite
  int quantity = 1;

  // Toggle favorite state
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.book.imageUrl,
                    height: 220,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 220),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.book.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FavoriteButton(
                    isFavorite: isFavorite,  // Pass the current favorite status
                    onTap: _toggleFavorite,  // Toggle the favorite status
                  ),
                ],
              ),
              Text(
                'GoodDay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.book.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Text("Review", style: Theme.of(context).textTheme.titleMedium),
              RatingStars(
                rating: widget.book.rating,
                reviewCount: widget.book.reviewCount,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
                  const Text("1"),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                  const Spacer(),
                  Text(
                    "\$${widget.book.price.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
