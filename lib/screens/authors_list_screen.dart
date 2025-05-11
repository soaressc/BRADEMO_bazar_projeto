import 'package:flutter/material.dart';

class Author {
  final String name;
  final String imageUrl;
  final String description;

  Author({
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

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
    return authors
        .where(
          (author) =>
              author.name.toLowerCase().contains(_searchText.toLowerCase()) ||
              author.description.toLowerCase().contains(
                _searchText.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            _isSearching
                ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar autores...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                )
                : const Text(
                  'Autores',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchText = '';
                _searchController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchText = '';
                  _searchController.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Autores'), Tab(text: 'Livros')],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verifique os autores',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Autores',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: filteredAuthors.length,
                  itemBuilder: (context, index) {
                    final author = filteredAuthors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
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
                // const Center(child: Text('Livros content will go here')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
