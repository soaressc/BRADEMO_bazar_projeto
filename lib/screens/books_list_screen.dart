import 'package:flutter/material.dart';
import '../models/book.dart';
//import '../widgets/book_card.dart';
import '../screens/product_detail_screen.dart';
import '../screens/gridview.dart';

class BooksListScreen extends StatelessWidget {
  final List<Book> books = [
    Book(
      id: '1',
      title: 'The Da Vinci Code',
      author: 'Dan Brown',
      imageUrl: 'assets/daVinci.jpg',
      description:
          'A gripping modern thriller about a secret society and religious conspiracies.',
      price: '\$19.99',
      rating: 4.5,
      reviewCount: 1200,
      store: 'Amazon',
    ),
    Book(
      id: '2',
      title: 'Carrie Fisher',
      author: 'Carrie Fisher',
      imageUrl: 'assets/carrieFisher.jpg',
      description:
          'A memoir by the legendary actress and writer, covering her personal life and career.',
      price: '\$27.12',
      rating: 4.7,
      reviewCount: 800,
      store: 'Barnes & Noble',
    ),
    Book(
      id: '3',
      title: 'The Good Sister',
      author: 'Sally Hepworth',
      imageUrl: 'assets/theGoodSister.jpg',
      description:
          'A thrilling story of family secrets and the bond between sisters.',
      price: '\$27.12',
      rating: 4.3,
      reviewCount: 950,
      store: 'Book Depository',
    ),
    Book(
      id: '4',
      title: 'The Waiting',
      author: 'Debbie Macomber',
      imageUrl: 'assets/theWaiting.jpg',
      description:
          'A heartwarming novel about love, hope, and the waiting game of life.',
      price: '\$27.12',
      rating: 4.2,
      reviewCount: 750,
      store: 'Amazon',
    ),
    Book(
      id: '5',
      title: 'Where Are You',
      author: 'Sara Zarr',
      imageUrl: 'assets/whereAreYou.png',
      description:
          'A poignant exploration of the search for identity and belonging.',
      price: '\$30.28',
      rating: 4.1,
      reviewCount: 600,
      store: 'Barnes & Noble',
    ),
    Book(
      id: '6',
      title: 'Bright Young Women',
      author: 'Jessica Hollander',
      imageUrl: 'assets/brightYoungWomen.jpg',
      description:
          'A captivating novel about the lives of three women navigating complex relationships.',
      price: '\$24.49',
      rating: 4.6,
      reviewCount: 1050,
      store: 'Book Depository',
    ),
  ];

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
    return GridViewBooks(
      books: books,
      onTap: (book) => _openProductDetail(context, book),
    );
  }
}
