import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/bottom_bar.dart';
import '../../screens/authors_list_screen.dart';
import '../../screens/books_list_screen.dart';
import 'product_detail_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

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
    return DefaultTabController(
      length: 2, // 2 abas: Livros e Autores
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: (){
                Navigator.pushNamed(context, '/notifications'); 
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: 'Livros'), Tab(text: 'Autores')],
          ),
        ),
        body: TabBarView(
          children: [
            BooksListScreen(), // primeira aba: grid de livros
            AuthorsListScreen(), // segunda aba: lista de autores
          ],
        ),
        bottomNavigationBar: BottomBar(
          selectedIndex: 0,
          onTap: (index) {
            if (index == 2) {
              Navigator.pushNamed(context, '/cart');
            }
            if (index == 3) {
              Navigator.pushNamed(context, '/profile');
            }
          },
        ),
      ),
    );
  }
}
