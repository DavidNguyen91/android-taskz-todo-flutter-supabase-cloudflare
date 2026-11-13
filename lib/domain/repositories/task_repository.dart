import '../models/task.dart';

/// Abstract contract for task persistence operations.
/// Follows Dependency Inversion Principle — Presentation and Domain
/// do not know or care about Supabase, SQLite, or HTTP details.
abstract interface class ITaskRepository {
  /// Fetches all tasks for the authenticated user, sorted by creation date descending.
  Future<List<Task>> getTasks();

  /// Creates a new task with the given title.
  Future<Task> createTask(String title);

  /// Updates task title and/or completion status.
  Future<Task> updateTask(
    String id, {
    String? title,
    bool? completed,
  });

  /// Deletes a task by ID.
  Future<void> deleteTask(String id);

  /// Deletes all completed tasks belonging to the authenticated user.
  Future<void> clearCompletedTasks();
}
