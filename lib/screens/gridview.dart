import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';

class GridViewBooks extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onTap;

  const GridViewBooks({super.key, required this.books, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: books.length,
      itemBuilder: (ctx, i) {
        final book = books[i];
        return BookCard(
          book: book,
          onTap: () => onTap(book), 
          isFavorite: false,
        );
      },
    );
  }
}
