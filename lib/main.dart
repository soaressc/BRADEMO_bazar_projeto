import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/signup_screen.dart';
import 'package:myapp/screens/home.dart';
import 'package:myapp/screens/onboarding_screen.dart';

void main() {
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
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const Home(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}
