import 'package:flutter/material.dart';
import '../widgets/bottom_bar.dart';

class CartEmptyScreen extends StatefulWidget {
  const CartEmptyScreen({super.key});

  @override
  _CartEmptyScreenState createState() => _CartEmptyScreenState();
}

class _CartEmptyScreenState extends State<CartEmptyScreen> {
  int _selectedIndex = 2; // Index para 'Cart'

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/category');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
  
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cart.png', 
              height: 100,
              width: 100,
              color: Colors.grey, 
            ),
            const SizedBox(height: 16),
            const Text(
              'There is no products',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
