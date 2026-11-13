import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';

/// Apple iOS-styled Header component.
/// Displays today's formatted date, user profile/logout action,
/// Large Title "My Tasks", remaining tasks badge, and subtitle.
class IosHeader extends StatelessWidget {
  final int activeCount;
  final int totalCount;
  final String? userEmail;
  final VoidCallback onSignOut;
  final AppStrings strings;

  const IosHeader({
    super.key,
    required this.activeCount,
    required this.totalCount,
    required this.onSignOut,
    this.userEmail,
    this.strings = const AppStrings(),
  });

  String _getFormattedDate() {
    return DateFormat('EEEE, MMM d').format(DateTime.now());
  }

  void _showSignOutDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(strings.signOutConfirmTitle),
        message: Text(userEmail != null
            ? '${strings.signOutConfirmMessage}\n($userEmail)'
            : strings.signOutConfirmMessage),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              onSignOut();
            },
            child: Text(strings.signOut),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(strings.cancel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAllDone = totalCount > 0 && activeCount == 0;

    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderSubtle = isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.lightSuccess;

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Uppercase Date & User Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getFormattedDate().toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: textSecondary,
                ),
              ),
              Semantics(
                button: true,
                label: strings.signOut,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: AppGeometry.minTouchTarget,
                  onPressed: () => _showSignOutDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkHover : AppColors.lightHover,
                      borderRadius: BorderRadius.circular(AppGeometry.radiusFull),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.person_crop_circle,
                          size: 16,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          strings.signOut,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title & Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  strings.myTasks,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: textPrimary,
                    height: 1.15,
                  ),
                ),
              ),
              if (totalCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAllDone
                        ? successColor.withValues(alpha: 0.12)
                        : (isDark ? AppColors.darkHover : AppColors.lightHover),
                    borderRadius: BorderRadius.circular(AppGeometry.radiusFull),
                    border: Border.all(
                      color: isAllDone
                          ? successColor.withValues(alpha: 0.3)
                          : borderSubtle,
                    ),
                  ),
                  child: Text(
                    isAllDone ? strings.allTasksCompleted : strings.remainingTasks(activeCount),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isAllDone ? FontWeight.w600 : FontWeight.w500,
                      color: isAllDone ? successColor : textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            strings.subtitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
