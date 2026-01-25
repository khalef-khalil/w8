import 'package:flutter/material.dart';

/// Skeleton loading widget for cards
class LoadingSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 20,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Skeleton card for loading states
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingSkeleton(width: 120, height: 20),
            const SizedBox(height: 16),
            LoadingSkeleton(width: double.infinity, height: 12),
            const SizedBox(height: 8),
            LoadingSkeleton(width: double.infinity, height: 12),
            const SizedBox(height: 8),
            LoadingSkeleton(width: 200, height: 12),
          ],
        ),
      ),
    );
  }
}
