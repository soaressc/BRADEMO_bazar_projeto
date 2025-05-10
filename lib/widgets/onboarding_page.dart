import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import 'action_buttons.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 40),
          Image.asset(data.imageAsset, height: 250),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ActionButtons(
              primaryLabel: primaryLabel,
              onPrimaryPressed: onPrimaryPressed,
              secondaryLabel: secondaryLabel,
              onSecondaryPressed: onSecondaryPressed,
            ),
          ),
        ],
      ),
    );
  }
}
