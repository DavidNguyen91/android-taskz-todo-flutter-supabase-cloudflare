import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/task.dart';

/// Apple iOS-styled Segmented Control for filtering tasks.
/// Displays counts badge for All, Active, and Completed,
/// along with the "Clear completed" action when applicable.
class IosSegmentedFilter extends StatelessWidget {
  final TaskFilter currentFilter;
  final TaskCounts counts;
  final ValueChanged<TaskFilter> onFilterChanged;
  final VoidCallback onClearCompleted;
  final AppStrings strings;

  const IosSegmentedFilter({
    super.key,
    required this.currentFilter,
    required this.counts,
    required this.onFilterChanged,
    required this.onClearCompleted,
    this.strings = const AppStrings(),
  });

  void _showClearConfirmDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(strings.clearCompletedConfirmTitle),
        message: Text(strings.clearCompletedConfirmMessage),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              HapticFeedback.mediumImpact();
              onClearCompleted();
            },
            child: Text(strings.clearCompleted),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(strings.cancel),
        ),
      ),
    );
  }

  Widget _buildSegmentItem({
    required BuildContext context,
    required String label,
    required int count,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? textPrimary : textSecondary,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkHover : AppColors.lightHover),
              borderRadius: BorderRadius.circular(AppGeometry.radiusFull),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? accentColor : textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dangerColor = isDark ? AppColors.darkDanger : AppColors.lightDanger;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CupertinoSlidingSegmentedControl<TaskFilter>(
                groupValue: currentFilter,
                backgroundColor: isDark ? AppColors.darkHover : const Color(0xFFE5E5EA),
                thumbColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                onValueChanged: (val) {
                  if (val != null) {
                    HapticFeedback.selectionClick();
                    onFilterChanged(val);
                  }
                },
                children: {
                  TaskFilter.all: _buildSegmentItem(
                    context: context,
                    label: strings.filterAll,
                    count: counts.total,
                    isSelected: currentFilter == TaskFilter.all,
                  ),
                  TaskFilter.active: _buildSegmentItem(
                    context: context,
                    label: strings.filterActive,
                    count: counts.active,
                    isSelected: currentFilter == TaskFilter.active,
                  ),
                  TaskFilter.completed: _buildSegmentItem(
                    context: context,
                    label: strings.filterCompleted,
                    count: counts.completed,
                    isSelected: currentFilter == TaskFilter.completed,
                  ),
                },
              ),
            ),
          ],
        ),
        if (counts.completed > 0) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minSize: AppGeometry.minTouchTarget,
              onPressed: () => _showClearConfirmDialog(context),
              child: Text(
                strings.clearCompleted,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: dangerColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
