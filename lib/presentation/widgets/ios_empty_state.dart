import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/task.dart';

/// Apple iOS-styled Empty State widget.
/// Aligned 100% with the Next.js Web reference states:
/// 1. No Tasks Yet (when total tasks == 0)
/// 2. All Caught Up (when active tasks == 0 in active filter)
/// 3. No Completed Tasks (when completed tasks == 0 in completed filter)
class IosEmptyState extends StatelessWidget {
  final TaskFilter filter;
  final bool hasAnyTasks;
  final AppStrings strings;

  const IosEmptyState({
    super.key,
    required this.filter,
    required this.hasAnyTasks,
    this.strings = const AppStrings(),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
    final hoverColor = isDark ? AppColors.darkHover : AppColors.lightHover;

    IconData icon;
    Color iconColor;
    Color iconBgColor;
    String title;
    String description;

    if (!hasAnyTasks) {
      icon = CupertinoIcons.tray;
      iconColor = textSecondary;
      iconBgColor = hoverColor;
      title = strings.emptyAllTitle;
      description = strings.emptyAllDescription;
    } else if (filter == TaskFilter.active) {
      icon = CupertinoIcons.sparkles;
      iconColor = successColor;
      iconBgColor = successColor.withValues(alpha: 0.12);
      title = strings.emptyActiveTitle;
      description = strings.emptyActiveDescription;
    } else {
      icon = CupertinoIcons.check_mark;
      iconColor = successColor;
      iconBgColor = successColor.withValues(alpha: 0.12);
      title = strings.emptyCompletedTitle;
      description = strings.emptyCompletedDescription;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppGeometry.radiusCard),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
