import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Apple iOS-styled Skeleton Loading animation.
/// Renders 3 pulse lines matching the Next.js `loadingPlaceholder` exactly.
class IosSkeletonLoading extends StatefulWidget {
  const IosSkeletonLoading({super.key});

  @override
  State<IosSkeletonLoading> createState() => _IosSkeletonLoadingState();
}

class _IosSkeletonLoadingState extends State<IosSkeletonLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLine({double? width}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white : Colors.black;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Container(
        height: 20,
        width: width,
        decoration: BoxDecoration(
          color: color.withValues(alpha: _animation.value * (isDark ? 0.15 : 0.08)),
          borderRadius: BorderRadius.circular(AppGeometry.radiusSm),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderSubtle = isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppGeometry.radiusCard),
        border: Border.all(color: borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLine(),
          const SizedBox(height: 12),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: _buildLine(),
          ),
          const SizedBox(height: 12),
          _buildLine(),
        ],
      ),
    );
  }
}
