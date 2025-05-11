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
        imageAsset: 'assets/onboarding1.png',
        title: 'Now reading books will be easier',
        description:
            'Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.',
        primaryLabel: 'Continue',
        secondaryLabel: 'Sign Up',
        onPrimaryPressed: () {
          _controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        onSecondaryPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
      ),
      OnboardingModel(
        imageAsset: 'assets/onboarding2.png',
        title: 'Start Your Adventure',
        description:
            'Ready to embark on a quest for inspiration and knowledge? Your adventure begins now!',
        primaryLabel: 'Get Started',
        secondaryLabel: 'Sign Up',
        onPrimaryPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        onSecondaryPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: pages.length,
          itemBuilder:
              (_, index) => OnboardingPage(
                data: pages[index],
                primaryLabel: pages[index].primaryLabel,
                onPrimaryPressed: pages[index].onPrimaryPressed,
                secondaryLabel: pages[index].secondaryLabel,
                onSecondaryPressed: pages[index].onSecondaryPressed,
                pageController: _controller,
                totalPages: pages.length,
              ),
          physics:
              BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
