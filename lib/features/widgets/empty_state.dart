import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final double spacing;

  const EmptyState({
    super.key,
    this.message = 'Nothing to display',
    this.icon = Icons.hourglass_empty,
    this.iconSize = 72,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: iconSize,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.6)),
          SizedBox(height: spacing),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}