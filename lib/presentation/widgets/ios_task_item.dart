import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/task.dart';

/// Apple iOS-styled Task Item row.
/// Features circular checkbox with spring scale animation,
/// subtle separator line, strike-through text, long-press to edit,
/// and swipe-to-delete.
class IosTaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<String> onToggle;
  final Future<bool> Function(String id, String newTitle) onEdit;
  final ValueChanged<String> onDelete;
  final AppStrings strings;

  const IosTaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.strings = const AppStrings(),
  });

  void _showEditDialog(BuildContext context) {
    final textController = TextEditingController(text: task.title);

    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(strings.editTaskTitle),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: textController,
            autofocus: true,
            maxLength: 300,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              final newTitle = textController.text.trim();
              if (newTitle.isNotEmpty && newTitle != task.title) {
                onEdit(task.id, newTitle);
              }
              Navigator.of(ctx).pop();
            },
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(strings.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              final newTitle = textController.text.trim();
              if (newTitle.isNotEmpty && newTitle != task.title) {
                onEdit(task.id, newTitle);
              }
              Navigator.of(ctx).pop();
            },
            child: Text(strings.saveTask),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderSubtle = isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final dangerColor = isDark ? AppColors.darkDanger : AppColors.lightDanger;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: dangerColor,
        child: const Icon(
          CupertinoIcons.trash,
          color: Colors.white,
          size: 22,
        ),
      ),
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete(task.id);
      },
      child: Semantics(
        label: task.completed ? 'Completed: ${task.title}' : 'Active: ${task.title}',
        child: InkWell(
          onLongPress: () => _showEditDialog(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Apple Checkbox with Touch Target >= 44x44
                Semantics(
                  button: true,
                  checked: task.completed,
                  label: task.completed ? 'Mark incomplete' : 'Mark complete',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onToggle(task.id);
                    },
                    child: Container(
                      width: AppGeometry.minTouchTarget,
                      height: AppGeometry.minTouchTarget,
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.completed ? accentColor : Colors.transparent,
                          border: Border.all(
                            color: task.completed ? accentColor : borderSubtle,
                            width: 1.5,
                          ),
                        ),
                        child: task.completed
                            ? const Icon(
                                CupertinoIcons.check_mark,
                                size: 13,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Task Title text with strike-through
                Expanded(
                  child: Text(
                    task.title,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      color: task.completed ? textSecondary : textPrimary,
                      decoration: task.completed ? TextDecoration.lineThrough : null,
                      decorationColor: textSecondary,
                    ),
                  ),
                ),

                // Quick Edit Action
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: AppGeometry.minTouchTarget,
                  onPressed: () => _showEditDialog(context),
                  child: Icon(
                    CupertinoIcons.pencil,
                    size: 18,
                    color: textSecondary.withValues(alpha: 0.6),
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
