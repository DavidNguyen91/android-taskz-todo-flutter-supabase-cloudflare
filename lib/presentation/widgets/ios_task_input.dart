import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';

/// Apple iOS-styled Quick Task Input bar.
/// Handles auto-focus, text trimming, double-submission protection,
/// and smooth submit animations.
class IosTaskInput extends StatefulWidget {
  final Future<bool> Function(String title) onAddTask;
  final bool isSubmitting;
  final AppStrings strings;

  const IosTaskInput({
    super.key,
    required this.onAddTask,
    this.isSubmitting = false,
    this.strings = const AppStrings(),
  });

  @override
  State<IosTaskInput> createState() => _IosTaskInputState();
}

class _IosTaskInputState extends State<IosTaskInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (_hasContent != hasText) {
        setState(() {
          _hasContent = hasText;
        });
      }
    });
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSubmitting) return;

    HapticFeedback.lightImpact();
    final success = await widget.onAddTask(text);
    if (success && mounted) {
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderSubtle = isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle;
    final accentColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final placeholderColor = isDark ? AppColors.darkTextPlaceholder : AppColors.lightTextPlaceholder;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    final canSubmit = _hasContent && !widget.isSubmitting;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppGeometry.radiusMd),
        border: Border.all(color: borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.add,
            size: 20,
            color: canSubmit ? accentColor : placeholderColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: _controller,
              focusNode: _focusNode,
              placeholder: widget.strings.taskInputPlaceholder,
              placeholderStyle: TextStyle(
                color: placeholderColor,
                fontSize: 16,
              ),
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
              ),
              decoration: const BoxDecoration(color: Colors.transparent),
              padding: const EdgeInsets.symmetric(vertical: 12),
              textInputAction: TextInputAction.done,
              maxLength: 300,
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            enabled: canSubmit,
            label: widget.strings.addTaskTooltip,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: AppGeometry.minTouchTarget,
              onPressed: canSubmit ? _submit : null,
              child: AnimatedOpacity(
                opacity: canSubmit ? 1.0 : 0.3,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: widget.isSubmitting
                      ? const CupertinoActivityIndicator(color: Colors.white, radius: 8)
                      : const Icon(
                          CupertinoIcons.arrow_up,
                          size: 18,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
