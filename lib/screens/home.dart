import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/tab_bar.dart';
import '../widgets/bottom_bar.dart';
import 'gridview.dart'; 

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Book> books = [
    Book(titulo: 'The Da Vinci Code', preco: '\$19.99', caminhoImagem: 'lib/assets/daVinci.jpg'),
    Book(titulo: 'Carrie Fisher', preco: '\$27.12', caminhoImagem: 'lib/assets/carrieFisher.jpg'),
    Book(titulo: 'The Good Sister', preco: '\$27.12', caminhoImagem: 'lib/assets/theGoodSister.jpg'),
    Book(titulo: 'The Waiting', preco: '\$27.12', caminhoImagem: 'lib/assets/theWaiting.jpg'),
    Book(titulo: 'Where Are You', preco: '\$30.28', caminhoImagem: 'lib/assets/whereAreYou.png'),
    Book(titulo: 'Bright Young Women', preco: '\$24.49', caminhoImagem: 'lib/assets/brightYoungWomen.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        actions: [IconButton(icon: const Icon(Icons.notifications_active), onPressed: () {})],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBarSection(),
          Expanded(
            child: GridViewBooks(books: books), 
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

