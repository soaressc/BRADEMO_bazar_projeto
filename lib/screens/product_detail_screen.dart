import 'package:flutter/material.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/widgets/favorite_button.dart';
import 'package:myapp/widgets/rating_stars.dart';
import 'package:myapp/widgets/action_buttons.dart';
import 'package:myapp/widgets/quantity_selector.dart';
import 'package:myapp/utils/session.dart';
import 'package:myapp/controller/cart_controller.dart';
import '../service/notification_service.dart';
import '../models/app_notification_model.dart';
import '../utils/favorite_storage.dart';

class ProductDetailScreen extends StatefulWidget {
  final Book book;

  const ProductDetailScreen({super.key, required this.book});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;
  int quantity = 1;
  final CartController _controller = CartController();

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  void _loadFavorite() async {
    final fav = await FavoriteStorage.isFavorite(widget.book.id);
    setState(() {
      isFavorite = fav;
    });
  }

  void _toggleFavorite() async {
    final newFavState = await FavoriteStorage.toggleFavorite(widget.book.id);
    setState(() {
      isFavorite = newFavState;
    });

    final title =
        isFavorite ? 'Livro Favoritado' : 'Livro Removido dos Favoritos';
    final message =
        '"${widget.book.title}" ${isFavorite ? 'foi adicionado aos favoritos!' : 'foi removido dos favoritos.'}';

    await showNotification(title, message);

    final appUser = await Session.getCurrentAppUser();
    if (appUser == null) return;

    final notificationService = NotificationService();
    final docRef = notificationService.notificationsRef.doc(); 


    final notification = AppNotification(
      id: docRef.id,
      userId: appUser.id,
      title: title,
      message: message,
      sentDate: DateTime.now(),
      read: false,
    );

    await docRef.set(notification);
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

  Future<void> _handleAddToCart() async {
    final appUser = await Session.getCurrentAppUser();

    if (appUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não autenticado ou não encontrado!'),
        ),
      );
      return;
    }

    try {
      await _controller.addToCart(appUser.id, widget.book, quantity);
      if (!mounted) return;
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 100));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro adicionado ao carrinho!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao adicionar: $e')));
    }
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
