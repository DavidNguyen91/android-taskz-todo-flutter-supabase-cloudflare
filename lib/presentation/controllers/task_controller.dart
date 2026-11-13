import 'package:flutter/foundation.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';

/// Presentation state controller for Task operations.
/// Encapsulates all business logic, optimistic updates, double-submission protection,
/// and rollback behavior. Completely decoupled from Flutter UI widgets.
class TaskController extends ChangeNotifier {
  final ITaskRepository taskRepository;

  List<Task> _tasks = const [];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  TaskController({required this.taskRepository});

  List<Task> get tasks => _tasks;
  TaskFilter get filter => _filter;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  TaskCounts get counts => TaskCounts.fromTasks(_tasks);

  List<Task> get filteredTasks {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((t) => !t.completed).toList();
      case TaskFilter.completed:
        return _tasks.where((t) => t.completed).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  /// Loads tasks from the repository.
  /// If [silent] is true, does not trigger full-screen loading indicator (ideal for pull-to-refresh).
  Future<void> loadTasks({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final loaded = await taskRepository.getTasks();
      _tasks = loaded;
      _errorMessage = null;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Failed to load tasks. Pull to refresh.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new task.
  /// Enforces double-submission protection via [_isSubmitting].
  Future<bool> addTask(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return false;
    if (_isSubmitting) return false;

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await taskRepository.createTask(trimmed);
      _tasks = [created, ..._tasks];
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Failed to create task.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Toggles task completion with Optimistic UI update and automatic rollback on failure.
  Future<void> toggleTask(String id) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) return;

    final currentTask = _tasks[taskIndex];
    final updatedStatus = !currentTask.completed;
    final rollbackSnapshot = List<Task>.from(_tasks);

    // Optimistic UI mutation
    _tasks = [
      for (final t in _tasks)
        if (t.id == id)
          t.copyWith(
            completed: updatedStatus,
            updatedAt: DateTime.now().toUtc(),
          )
        else
          t,
    ];
    notifyListeners();

    try {
      final updated = await taskRepository.updateTask(id, completed: updatedStatus);
      // Synchronize exact server updatedAt
      _tasks = [
        for (final t in _tasks)
          if (t.id == id) updated else t,
      ];
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _tasks = rollbackSnapshot;
      _errorMessage = 'Failed to update task status.';
      notifyListeners();
    }
  }

  /// Edits task title with Optimistic UI update and rollback.
  Future<bool> editTask(String id, String newTitle) async {
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty) return false;

    final taskIndex = _tasks.indexWhere((t) => t.id == id);
    if (taskIndex == -1) return false;

    final currentTask = _tasks[taskIndex];
    if (currentTask.title == trimmed) return true;

    final rollbackSnapshot = List<Task>.from(_tasks);

    // Optimistic update
    _tasks = [
      for (final t in _tasks)
        if (t.id == id)
          t.copyWith(
            title: trimmed,
            updatedAt: DateTime.now().toUtc(),
          )
        else
          t,
    ];
    notifyListeners();

    try {
      final updated = await taskRepository.updateTask(id, title: trimmed);
      _tasks = [
        for (final t in _tasks)
          if (t.id == id) updated else t,
      ];
      notifyListeners();
      return true;
    } catch (e) {
      _tasks = rollbackSnapshot;
      _errorMessage = 'Failed to update task title.';
      notifyListeners();
      return false;
    }
  }

  /// Deletes a task by ID with Optimistic UI update and rollback.
  Future<void> deleteTask(String id) async {
    final rollbackSnapshot = List<Task>.from(_tasks);

    // Optimistic removal
    _tasks = _tasks.where((t) => t.id != id).toList();
    notifyListeners();

    try {
      await taskRepository.deleteTask(id);
    } catch (e) {
      _tasks = rollbackSnapshot;
      _errorMessage = 'Failed to delete task.';
      notifyListeners();
    }
  }

  /// Clears all completed tasks with Optimistic UI update and rollback.
  Future<void> clearCompleted() async {
    final rollbackSnapshot = List<Task>.from(_tasks);

    // Optimistic removal
    _tasks = _tasks.where((t) => !t.completed).toList();
    notifyListeners();

    try {
      await taskRepository.clearCompletedTasks();
    } catch (e) {
      _tasks = rollbackSnapshot;
      _errorMessage = 'Failed to clear completed tasks.';
      notifyListeners();
    }
  }

  /// Switches task filter.
  void setFilter(TaskFilter filter) {
    if (_filter != filter) {
      _filter = filter;
      notifyListeners();
    }
  }

  /// Clears error message banner.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Clears in-memory data on user logout.
  void clearData() {
    _tasks = const [];
    _filter = TaskFilter.all;
    _errorMessage = null;
    _isLoading = false;
    _isSubmitting = false;
    notifyListeners();
  }
}
