import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/product_detail_screen.dart';
import '../screens/gridview.dart';
import '../service/book_service.dart'; // 🔥 Certifique-se que o path tá certo

class BooksListScreen extends StatelessWidget {
  final BookService _bookService = BookService();

  void _openProductDetail(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailScreen(book: book),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Book>>(
      future: _bookService.fetchBookMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar livros: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum livro encontrado.'));
        }

        final books = snapshot.data!.values.toList();

        return GridViewBooks(
          books: books,
          onTap: (book) => _openProductDetail(context, book),
        );
      },
    );
  }
}
