import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const QuantitySelector({
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onRemove, icon: const Icon(Icons.remove)),
        Text(quantity.toString()),
        IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
      ],
    );
  }
}
