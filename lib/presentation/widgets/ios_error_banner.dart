import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';

/// Apple iOS-styled Error Banner with dismiss and retry action.
class IosErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback onDismiss;
  final AppStrings strings;

  const IosErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
    this.onRetry,
    this.strings = const AppStrings(),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dangerColor = isDark ? AppColors.darkDanger : AppColors.lightDanger;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: dangerColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppGeometry.radiusMd),
        border: Border.all(
          color: dangerColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle_fill,
            color: dangerColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: dangerColor,
              ),
            ),
          ),
          if (onRetry != null) ...[
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minSize: AppGeometry.minTouchTarget,
              onPressed: onRetry,
              child: Text(
                strings.retry,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: dangerColor,
                ),
              ),
            ),
          ],
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: AppGeometry.minTouchTarget,
            onPressed: onDismiss,
            child: Icon(
              CupertinoIcons.xmark,
              size: 16,
              color: dangerColor,
            ),
          ),
        ],
      ),
    );
  }
}
