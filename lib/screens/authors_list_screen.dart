import 'package:flutter/material.dart';
import '../models/author.dart';

class AuthorsListScreen extends StatefulWidget {
  const AuthorsListScreen({super.key});

  @override
  _AuthorsListScreenState createState() => _AuthorsListScreenState();
}

class _AuthorsListScreenState extends State<AuthorsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  bool _isSearching = false;
  String _searchText = '';

  final List<Author> authors = [
    Author(
      name: 'John Freeman',
      imageUrl: 'assets/John.png',
      description: 'American writer he  was the editor of the',
    ),
    Author(
      name: 'Adam Dalva',
      imageUrl: 'assets/Adam.png',
      description: 'He is the senior fiction editor of guernica ma',
    ),
    Author(
      name: 'Abraham verghese',
      imageUrl: 'assets/Abraham.png',
      description: 'He is the professor and Linda R . Meier and',
    ),
    Author(
      name: 'Tess Gunty',
      imageUrl: 'assets/Tess.png',
      description: 'Gunty was born and raised in south bend,indiana',
    ),
    Author(
      name: 'Ann Napolitano',
      imageUrl: 'assets/Ann.png',
      description: 'She is the author of the novels A Good Hard',
    ),
    Author(
      name: 'Hernan Diaz',
      imageUrl: 'assets/Hernan.png',
      description: 'He is Hernan Diaz',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.index == 1) {
        Future.delayed(Duration.zero, () {
          _tabController.index = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Author> get filteredAuthors {
    if (_searchText.isEmpty) return authors;
    return authors.where((author) {
      final lc = _searchText.toLowerCase();
      return author.name.toLowerCase().contains(lc) ||
          author.description.toLowerCase().contains(lc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Verifique os autores',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Autores',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _searchText = '';
                      _searchController.clear();
                    }
                    _isSearching = !_isSearching;
                  });
                },
              ),
            ],
          ),
        ),

        if (_isSearching)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: 8,
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Pesquisar autores…',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchText = '';
                      _searchController.clear();
                    });
                  },
                ),
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
          ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: ListView.builder(
              itemCount: filteredAuthors.length,
              itemBuilder: (ctx, i) {
                final author = filteredAuthors[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(author.imageUrl),
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              author.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              author.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
