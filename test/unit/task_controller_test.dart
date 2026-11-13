import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/core/errors/app_exceptions.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/repositories/task_repository.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/controllers/task_controller.dart';

class FakeTaskRepository implements ITaskRepository {
  List<Task> tasks = [];
  bool shouldThrow = false;
  int createTaskCallCount = 0;

  @override
  Future<List<Task>> getTasks() async {
    if (shouldThrow) throw const NetworkException('Network error');
    return List.from(tasks);
  }

  @override
  Future<Task> createTask(String title) async {
    createTaskCallCount++;
    if (shouldThrow) throw const ServerException('Server error');
    final now = DateTime.now().toUtc();
    final task = Task(
      id: 'task-${tasks.length + 1}',
      title: title,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );
    tasks.insert(0, task);
    return task;
  }

  @override
  Future<Task> updateTask(String id, {String? title, bool? completed}) async {
    if (shouldThrow) throw const ServerException('Update error');
    final index = tasks.indexWhere((t) => t.id == id);
    if (index == -1) throw const ValidationException('Task not found');
    final current = tasks[index];
    final updated = current.copyWith(
      title: title ?? current.title,
      completed: completed ?? current.completed,
      updatedAt: DateTime.now().toUtc(),
    );
    tasks[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteTask(String id) async {
    if (shouldThrow) throw const ServerException('Delete error');
    tasks.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> clearCompletedTasks() async {
    if (shouldThrow) throw const ServerException('Clear error');
    tasks.removeWhere((t) => t.completed);
  }
}

void main() {
  late FakeTaskRepository repository;
  late TaskController controller;

  setUp(() {
    repository = FakeTaskRepository();
    controller = TaskController(taskRepository: repository);
  });

  group('TaskController Unit Tests', () {
    test('loadTasks should update tasks and calculate counts', () async {
      final now = DateTime.utc(2026, 11, 13);
      repository.tasks = [
        Task(id: '1', title: 'Task 1', completed: false, createdAt: now, updatedAt: now),
        Task(id: '2', title: 'Task 2', completed: true, createdAt: now, updatedAt: now),
      ];

      await controller.loadTasks();

      expect(controller.tasks.length, 2);
      expect(controller.counts.total, 2);
      expect(controller.counts.active, 1);
      expect(controller.counts.completed, 1);
      expect(controller.errorMessage, isNull);
    });

    test('loadTasks failure should set errorMessage', () async {
      repository.shouldThrow = true;
      await controller.loadTasks();

      expect(controller.tasks, isEmpty);
      expect(controller.errorMessage, contains('Network error'));
    });

    test('addTask should reject empty or whitespace-only title', () async {
      final emptyResult = await controller.addTask('');
      final whitespaceResult = await controller.addTask('   ');

      expect(emptyResult, isFalse);
      expect(whitespaceResult, isFalse);
      expect(repository.createTaskCallCount, 0);
      expect(controller.tasks, isEmpty);
    });

    test('addTask should successfully add task to top of list', () async {
      final result = await controller.addTask('New Valid Task');

      expect(result, isTrue);
      expect(controller.tasks.length, 1);
      expect(controller.tasks.first.title, 'New Valid Task');
      expect(controller.tasks.first.completed, isFalse);
    });

    test('toggleTask should update status optimistically and rollback on error', () async {
      final now = DateTime.utc(2026, 11, 13);
      repository.tasks = [
        Task(id: '1', title: 'Task 1', completed: false, createdAt: now, updatedAt: now),
      ];
      await controller.loadTasks();

      // Successful toggle
      await controller.toggleTask('1');
      expect(controller.tasks.first.completed, isTrue);

      // Failed toggle with automatic rollback
      repository.shouldThrow = true;
      await controller.toggleTask('1');
      expect(controller.tasks.first.completed, isTrue); // rolled back to true
      expect(controller.errorMessage, contains('Failed to update task status'));
    });

    test('editTask should update title optimistically and rollback on error', () async {
      final now = DateTime.utc(2026, 11, 13);
      repository.tasks = [
        Task(id: '1', title: 'Original Title', completed: false, createdAt: now, updatedAt: now),
      ];
      await controller.loadTasks();

      final success = await controller.editTask('1', 'New Title');
      expect(success, isTrue);
      expect(controller.tasks.first.title, 'New Title');

      // Failure rollback
      repository.shouldThrow = true;
      final failResult = await controller.editTask('1', 'Failing Title');
      expect(failResult, isFalse);
      expect(controller.tasks.first.title, 'New Title'); // Rolled back
    });

    test('deleteTask should remove item optimistically and rollback on failure', () async {
      final now = DateTime.utc(2026, 11, 13);
      repository.tasks = [
        Task(id: '1', title: 'Task to delete', completed: false, createdAt: now, updatedAt: now),
      ];
      await controller.loadTasks();

      repository.shouldThrow = true;
      await controller.deleteTask('1');

      // Rolled back
      expect(controller.tasks.length, 1);
      expect(controller.errorMessage, contains('Failed to delete task'));

      // Successful delete
      repository.shouldThrow = false;
      await controller.deleteTask('1');
      expect(controller.tasks, isEmpty);
    });

    test('clearCompleted should remove all completed tasks', () async {
      final now = DateTime.utc(2026, 11, 13);
      repository.tasks = [
        Task(id: '1', title: 'Active', completed: false, createdAt: now, updatedAt: now),
        Task(id: '2', title: 'Done 1', completed: true, createdAt: now, updatedAt: now),
        Task(id: '3', title: 'Done 2', completed: true, createdAt: now, updatedAt: now),
      ];
      await controller.loadTasks();

      await controller.clearCompleted();

      expect(controller.tasks.length, 1);
      expect(controller.tasks.first.title, 'Active');
    });

    test('filtering should return matching tasks for all, active, completed', () async {
      final now = DateTime.utc(2026, 11, 13);
      repository.tasks = [
        Task(id: '1', title: 'Active 1', completed: false, createdAt: now, updatedAt: now),
        Task(id: '2', title: 'Done 1', completed: true, createdAt: now, updatedAt: now),
      ];
      await controller.loadTasks();

      controller.setFilter(TaskFilter.active);
      expect(controller.filteredTasks.length, 1);
      expect(controller.filteredTasks.first.title, 'Active 1');

      controller.setFilter(TaskFilter.completed);
      expect(controller.filteredTasks.length, 1);
      expect(controller.filteredTasks.first.title, 'Done 1');

      controller.setFilter(TaskFilter.all);
      expect(controller.filteredTasks.length, 2);
    });

    test('clearData should purge in-memory state on logout', () async {
      await controller.addTask('Some task');
      controller.setFilter(TaskFilter.completed);

      controller.clearData();

      expect(controller.tasks, isEmpty);
      expect(controller.filter, TaskFilter.all);
      expect(controller.errorMessage, isNull);
    });
  });
}
