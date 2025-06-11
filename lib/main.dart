import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/cart.dart';
import 'package:myapp/models/cart_item.dart';
import 'package:myapp/screens/auth/signup_screen.dart';
import 'package:myapp/screens/cart_screen.dart';
import 'package:myapp/screens/home.dart';
import 'package:myapp/screens/onboarding_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/screens/address_screen.dart';
import 'package:myapp/screens/splash_screen.dart';
//import 'package:myapp/screens/cart_empty_screen.dart';
import 'package:myapp/screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bazar Books',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const Home(),
        '/signup': (context) => const SignUpScreen(),
        '/cart':
            (context) => CartScreen(
              cart: createMockCart(),
            ), // Passing the mock cart here
        '/notifications': (context) => NotificationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/address': (context) => const AddressScreen(),
      },
    );
  }
}

Cart createMockCart() {
  final cartItem = CartItem(
    id: '1',
    cartId: 'test1',
    book: Book(
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
    quantidade: 2,
  );

  return Cart(id: '1a', usuarioId: '1', itens: [cartItem]);
}
