import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final List<OnboardingModel> pages = [];

  @override
  void initState() {
    super.initState();

    pages.addAll([
      OnboardingModel(
        imageAsset: 'assets/images/onboarding1.png',
        title: 'Now reading books will be easier',
        description:
            'Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.',
        primaryLabel: 'Continue',
        secondaryLabel: 'Sign In',
        onPrimaryPressed: () {
          _controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        onSecondaryPressed: () {
          Navigator.pushNamed(context, '/signin');
        },
      ),
      OnboardingModel(
        imageAsset: 'assets/images/onboarding2.png',
        title: 'Your Bookish Soulmate Awaits',
        description:
            'Let us be your guide to the perfect read. Discover books tailored to your tastes.',
        primaryLabel: 'Get Started',
        secondaryLabel: 'Sign In',
        onPrimaryPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        onSecondaryPressed: () {
          Navigator.pushNamed(context, '/signin');
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: OnboardingPage(
            data: pages[index],
            primaryLabel: pages[index].primaryLabel,
            onPrimaryPressed: pages[index].onPrimaryPressed,
            secondaryLabel: pages[index].secondaryLabel,
            onSecondaryPressed: pages[index].onSecondaryPressed,
          ),
        ),
      ),
    );
  }
}
