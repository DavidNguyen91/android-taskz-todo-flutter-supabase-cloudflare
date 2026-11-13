import 'package:flutter/foundation.dart';

/// Filter options for tasks.
enum TaskFilter {
  all,
  active,
  completed,
}

/// Immutable Domain Entity representing a To-Do task.
/// Pure Dart model, completely decoupled from any persistence framework or SDK.
@immutable
class Task {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy of this Task with optional updated fields.
  Task copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      completed.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'Task(id: $id, title: "$title", completed: $completed, createdAt: $createdAt, updatedAt: $updatedAt)';
}

/// Value object representing task metrics.
@immutable
class TaskCounts {
  final int total;
  final int active;
  final int completed;

  const TaskCounts({
    required this.total,
    required this.active,
    required this.completed,
  });

  factory TaskCounts.fromTasks(List<Task> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.completed).length;
    final active = total - completed;
    return TaskCounts(total: total, active: active, completed: completed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCounts &&
          runtimeType == other.runtimeType &&
          total == other.total &&
          active == other.active &&
          completed == other.completed;

  @override
  int get hashCode => total.hashCode ^ active.hashCode ^ completed.hashCode;
}
