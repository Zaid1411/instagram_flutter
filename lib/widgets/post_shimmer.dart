import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEFEFEF),
      highlightColor: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(radius: 16, backgroundColor: Colors.white),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Immersive Image Block
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: LoadingIndicator(size: 32),
              ),
            ),
          ),
          // Action Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _circle(24),
                const SizedBox(width: 12),
                _circle(24),
                const SizedBox(width: 12),
                _circle(24),
              ],
            ),
          ),
          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 80, height: 10, decoration: _box()),
                const SizedBox(height: 8),
                Container(width: 200, height: 10, decoration: _box()),
                const SizedBox(height: 4),
                Container(width: 140, height: 10, decoration: _box()),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _circle(double size) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      );

  BoxDecoration _box() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      );
}

class LoadingIndicator extends StatefulWidget {
  final double size;
  const LoadingIndicator({super.key, this.size = 24});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.string(
        '''<svg aria-label="Loading..." fill="#8E8E8E" height="${widget.size}" role="img" viewBox="0 0 100 100" width="${widget.size}"><rect height="6" opacity="0" rx="3" ry="3" transform="rotate(-90 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.08" rx="3" ry="3" transform="rotate(-60 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.16" rx="3" ry="3" transform="rotate(-30 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.25" rx="3" ry="3" transform="rotate(0 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.33" rx="3" ry="3" transform="rotate(30 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.41" rx="3" ry="3" transform="rotate(60 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.5" rx="3" ry="3" transform="rotate(90 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.58" rx="3" ry="3" transform="rotate(120 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.66" rx="3" ry="3" transform="rotate(150 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.75" rx="3" ry="3" transform="rotate(180 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.83" rx="3" ry="3" transform="rotate(210 50 50)" width="25" x="72" y="47"></rect><rect height="6" opacity="0.91" rx="3" ry="3" transform="rotate(240 50 50)" width="25" x="72" y="47"></rect></svg>''',
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}