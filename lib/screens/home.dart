import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/service/notification_service.dart';
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
  final NotificationService _notificationService = NotificationService();
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
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home'),
          actions: [
            if (userId != null)
              StreamBuilder(
                stream: _notificationService.getNotificationsStream(userId),
                builder: (context, snapshot) {
                  final notifications = snapshot.data ?? [];
                  final unreadCount =
                      notifications.where((n) => !n.read).length;

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/notifications',
                            arguments: userId,
                          );
                        },
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
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
        body: TabBarView(children: [BooksListScreen(), AuthorsListScreen()]),
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
