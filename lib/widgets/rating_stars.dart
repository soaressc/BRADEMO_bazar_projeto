import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingStars({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final stars = List.generate(
      5,
      (index) => Icon(
        index < fullStars ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 20,
      ),
    );

    return Row(
      children: [
        ...stars,
        const SizedBox(width: 8),
        Text(
          "($reviewCount)",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
