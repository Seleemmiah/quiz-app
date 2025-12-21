import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class QuizCardSkeleton extends StatelessWidget {
  const QuizCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const LoadingSkeleton(height: 40, width: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingSkeleton(
                        height: 16,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      LoadingSkeleton(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoadingSkeleton(
                  height: 12,
                  width: 80,
                  borderRadius: BorderRadius.circular(4),
                ),
                LoadingSkeleton(
                  height: 12,
                  width: 60,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StudentCardSkeleton extends StatelessWidget {
  const StudentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const LoadingSkeleton(
          height: 50,
          width: 50,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        title: LoadingSkeleton(
          height: 16,
          width: double.infinity,
          borderRadius: BorderRadius.circular(4),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: LoadingSkeleton(
            height: 12,
            width: 120,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class AnalyticsCardSkeleton extends StatelessWidget {
  const AnalyticsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LoadingSkeleton(height: 24, width: 24),
                LoadingSkeleton(
                  height: 32,
                  width: 32,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LoadingSkeleton(
              height: 24,
              width: 80,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            LoadingSkeleton(
              height: 12,
              width: 120,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget Function() itemBuilder;

  const ListSkeleton({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(),
    );
  }
}
