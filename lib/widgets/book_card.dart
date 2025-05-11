import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final bool isFavorite;

  const BookCard({
    Key? key,
    required this.book,
    required this.onTap,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Image.network(
              book.imageUrl,
              height: 160,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(book.title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(book.author),
            ),
          ],
        ),
      ),
    );
  }
}
