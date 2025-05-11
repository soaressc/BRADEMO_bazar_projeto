import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'product_detail_screen.dart';

class GridViewBooks extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onTap;

  const GridViewBooks({super.key, required this.books, required this.onTap});

  void _openProductDetail(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailScreen(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () => _openProductDetail(context, book),
          child: BookCard(
            book: book,
            onTap: () => _openProductDetail(context, book),
            isFavorite: false,
          ),
        );
      },
    );
  }
}
