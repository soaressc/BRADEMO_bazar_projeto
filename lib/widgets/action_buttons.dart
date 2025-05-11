import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final String secondaryLabel;
  final VoidCallback onSecondaryPressed;
  final bool isVertical;

  const ActionButtons({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    required this.secondaryLabel,
    required this.onSecondaryPressed,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return isVertical
        ? Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                ),
                onPressed: onPrimaryPressed,
                child: Text(primaryLabel),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.primary,
                  side: BorderSide(color: scheme.primary),
                ),
                onPressed: onSecondaryPressed,
                child: Text(secondaryLabel),
              ),
            ),
          ],
        )
        : Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                ),
                onPressed: onPrimaryPressed,
                child: Text(primaryLabel),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.primary,
                  side: BorderSide(color: scheme.primary),
                ),
                onPressed: onSecondaryPressed,
                child: Text(secondaryLabel),
              ),
            ),
          ],
        );
  }
}
