import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/screens/auth/signup_screen.dart';
import 'package:myapp/screens/home.dart';
import 'package:myapp/screens/onboarding_screen.dart';
import 'package:myapp/screens/splash_screen.dart';
import 'package:myapp/screens/cart_empty_screen.dart';
import 'package:myapp/screens/notification_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
        '/cart': (context) => const CartEmptyScreen(),
        '/notifications': (context) => NotificationScreen(),
      },
    );
  }
}
