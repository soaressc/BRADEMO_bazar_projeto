import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:camera/camera.dart'; 

// Telas
import 'package:myapp/screens/auth/signup_screen.dart';
import 'package:myapp/screens/home.dart';
import 'package:myapp/screens/onboarding_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/screens/address_screen.dart';
import 'package:myapp/screens/splash_screen.dart';
import 'package:myapp/screens/notification_screen.dart';
import 'package:myapp/controller/cart_wrapper.dart';

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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const Home(),
        '/signup': (context) => const SignUpScreen(),
        '/cart': (context) => const CartWrapper(),
        '/notifications': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return NotificationScreen(userId: args);
        },
        '/profile': (context) => const ProfileScreen(),
        '/address': (context) => const AddressScreen(),
      },
    );
  }
}
