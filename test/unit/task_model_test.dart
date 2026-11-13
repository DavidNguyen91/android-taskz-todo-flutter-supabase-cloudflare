import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';

void main() {
  group('Task Entity Tests', () {
    final now = DateTime.utc(2026, 11, 13, 12, 0, 0);

    test('should construct Task with all properties correctly', () {
      final task = Task(
        id: 'task-123',
        title: 'Buy organic milk',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(task.id, 'task-123');
      expect(task.title, 'Buy organic milk');
      expect(task.completed, isFalse);
      expect(task.createdAt, now);
      expect(task.updatedAt, now);
    });

    test('should copyWith fields accurately', () {
      final task = Task(
        id: 'task-1',
        title: 'Initial Title',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      final updatedNow = DateTime.utc(2026, 11, 13, 12, 5, 0);
      final updated = task.copyWith(
        title: 'Updated Title',
        completed: true,
        updatedAt: updatedNow,
      );

      expect(updated.id, 'task-1');
      expect(updated.title, 'Updated Title');
      expect(updated.completed, isTrue);
      expect(updated.createdAt, now);
      expect(updated.updatedAt, updatedNow);
    });

    test('should verify equality and hashCode', () {
      final task1 = Task(
        id: '1',
        title: 'Task A',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );
      final task2 = Task(
        id: '1',
        title: 'Task A',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );
      final task3 = Task(
        id: '2',
        title: 'Task B',
        completed: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(task1, equals(task2));
      expect(task1.hashCode, equals(task2.hashCode));
      expect(task1, isNot(equals(task3)));
    });
  });

  group('TaskCounts Tests', () {
    test('should correctly compute total, active, and completed metrics', () {
      final now = DateTime.utc(2026, 11, 13);
      final tasks = [
        Task(id: '1', title: 'Task 1', completed: false, createdAt: now, updatedAt: now),
        Task(id: '2', title: 'Task 2', completed: true, createdAt: now, updatedAt: now),
        Task(id: '3', title: 'Task 3', completed: false, createdAt: now, updatedAt: now),
        Task(id: '4', title: 'Task 4', completed: true, createdAt: now, updatedAt: now),
        Task(id: '5', title: 'Task 5', completed: false, createdAt: now, updatedAt: now),
      ];

      final counts = TaskCounts.fromTasks(tasks);

      expect(counts.total, 5);
      expect(counts.active, 3);
      expect(counts.completed, 2);
    });

    test('should return zero metrics for empty task list', () {
      final counts = TaskCounts.fromTasks([]);
      expect(counts.total, 0);
      expect(counts.active, 0);
      expect(counts.completed, 0);
    });
  });
}
