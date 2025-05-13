import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/onboarding_model.dart';
import 'action_buttons.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final PageController? pageController;
  final int totalPages;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.pageController,
    this.totalPages = 0,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isVertical = MediaQuery.of(context).size.width < 600;

    return Stack(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: size.height * 0.45,
                child: Image.asset(data.imageAsset, fit: BoxFit.contain),
              ),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              if (pageController != null)
                SmoothPageIndicator(
                  controller: pageController!,
                  count: totalPages,
                  effect: WormEffect(
                    dotColor: Colors.grey.shade300,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                  onDotClicked: (index) {
                    pageController!.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ActionButtons(
                primaryLabel: primaryLabel,
                onPrimaryPressed: onPrimaryPressed,
                secondaryLabel: secondaryLabel,
                onSecondaryPressed: onSecondaryPressed,
                isVertical: isVertical,
              ),
            ],
          ),
        ),
        // Botão Skip no canto superior esquerdo
        Positioned(
          top: 12,
          left: 12,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            child: const Text("Skip"),
          ),
        ),
      ],
    );
  }
}
