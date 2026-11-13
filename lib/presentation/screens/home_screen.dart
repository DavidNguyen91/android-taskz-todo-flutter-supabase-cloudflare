import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../widgets/ios_empty_state.dart';
import '../widgets/ios_error_banner.dart';
import '../widgets/ios_header.dart';
import '../widgets/ios_segmented_filter.dart';
import '../widgets/ios_skeleton_loading.dart';
import '../widgets/ios_task_input.dart';
import '../widgets/ios_task_item.dart';

/// Apple iOS-styled Main Screen.
/// Combines large sliver navigation, grouped task list, instant filtering,
/// pull-to-refresh spring physics, and app lifecycle resumption sync.
class HomeScreen extends StatefulWidget {
  final AuthController authController;
  final TaskController taskController;
  final AppStrings strings;

  const HomeScreen({
    super.key,
    required this.authController,
    required this.taskController,
    this.strings = const AppStrings(),
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial fetch
    widget.taskController.loadTasks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Silent background synchronization when user resumes app
    if (state == AppLifecycleState.resumed && widget.authController.isAuthenticated) {
      widget.taskController.loadTasks(silent: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderSubtle = isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle;
    final dividerColor = isDark ? AppColors.darkBorderDivider : AppColors.lightBorderDivider;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.taskController,
          builder: (context, _) {
            final tasks = widget.taskController.filteredTasks;
            final counts = widget.taskController.counts;
            final filter = widget.taskController.filter;
            final isLoading = widget.taskController.isLoading;
            final isSubmitting = widget.taskController.isSubmitting;
            final errorMessage = widget.taskController.errorMessage;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // iOS Native Pull to Refresh
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await widget.taskController.loadTasks(silent: true);
                  },
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Header
                      IosHeader(
                        activeCount: counts.active,
                        totalCount: counts.total,
                        userEmail: widget.authController.user?.email,
                        onSignOut: () async {
                          widget.taskController.clearData();
                          await widget.authController.signOut();
                        },
                        strings: widget.strings,
                      ),
                      const SizedBox(height: 20),

                      // Task Input Bar
                      IosTaskInput(
                        onAddTask: widget.taskController.addTask,
                        isSubmitting: isSubmitting,
                        strings: widget.strings,
                      ),
                      const SizedBox(height: 20),

                      // Error Banner
                      if (errorMessage != null)
                        IosErrorBanner(
                          message: errorMessage,
                          onDismiss: widget.taskController.clearError,
                          onRetry: () => widget.taskController.loadTasks(),
                          strings: widget.strings,
                        ),

                      // Loading Skeleton Placeholder
                      if (isLoading)
                        const IosSkeletonLoading()
                      else ...[
                        // Filter Segmented Control (only when tasks exist)
                        if (counts.total > 0) ...[
                          IosSegmentedFilter(
                            currentFilter: filter,
                            counts: counts,
                            onFilterChanged: widget.taskController.setFilter,
                            onClearCompleted: widget.taskController.clearCompleted,
                            strings: widget.strings,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Tasks Grouped Card or Empty State
                        if (tasks.isEmpty)
                          IosEmptyState(
                            filter: filter,
                            hasAnyTasks: counts.total > 0,
                            strings: widget.strings,
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(AppGeometry.radiusCard),
                              border: Border.all(color: borderSubtle),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: tasks.length,
                              separatorBuilder: (context, index) => Divider(
                                color: dividerColor,
                                height: 1,
                                thickness: 1,
                                indent: 52, // iOS HIG indented divider
                              ),
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return IosTaskItem(
                                  task: task,
                                  onToggle: widget.taskController.toggleTask,
                                  onEdit: widget.taskController.editTask,
                                  onDelete: widget.taskController.deleteTask,
                                  strings: widget.strings,
                                );
                              },
                            ),
                          ),
                      ],
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
