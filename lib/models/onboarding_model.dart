import 'package:flutter/material.dart';

class OnboardingModel {
  final String imageAsset;
  final String title;
  final String description;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  OnboardingModel({
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });
}
