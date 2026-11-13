import '../../domain/models/task.dart';

/// Data Transfer Object for serializing/deserializing tasks with Supabase PostgreSQL.
final class TaskDto {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskDto({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to parse JSON received from Supabase `tasks` table.
  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toUtc(),
    );
  }

  /// Converts DTO to Supabase payload for insert/upsert.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  /// Maps DTO to Domain Entity.
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      completed: completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Maps Domain Entity to DTO.
  factory TaskDto.fromEntity(Task task) {
    return TaskDto(
      id: task.id,
      title: task.title,
      completed: task.completed,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}
