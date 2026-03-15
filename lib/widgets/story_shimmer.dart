import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmer extends StatelessWidget {
  const StoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 7,
        itemBuilder: (ctx, i) => Shimmer.fromColors(
          baseColor: const Color(0xFFE8E8E8),
          highlightColor: const Color(0xFFF5F5F5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                const CircleAvatar(radius: 32, backgroundColor: Colors.white),
                const SizedBox(height: 6),
                Container(
                  height: 9,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
