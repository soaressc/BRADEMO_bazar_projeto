import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/tab_bar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/book_card.dart';
import 'product_detail_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Book> books = [
    Book(
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

  // Método para abrir os detalhes do produto
  void _openProductDetail(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailScreen(book: book),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBarSection(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),

              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(
                  book: book,
                  onTap: () => _openProductDetail(context, book),
                  isFavorite: false,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onTap: (int index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/cart');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
