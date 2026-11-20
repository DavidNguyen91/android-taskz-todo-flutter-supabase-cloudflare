import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/auth_user.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/repositories/auth_repository.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/repositories/task_repository.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/controllers/auth_controller.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/controllers/task_controller.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/screens/home_screen.dart';

class StubAuthRepo implements IAuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  AuthUser? get currentUser =>
      const AuthUser(id: 'u1', email: 'tester@example.com');

  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signUpWithPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}
}

class StubTaskRepo implements ITaskRepository {
  List<Task> stored = [
    Task(
      id: 'task-1',
      title: 'First Home Task',
      completed: false,
      createdAt: DateTime.utc(2026, 11, 13),
      updatedAt: DateTime.utc(2026, 11, 13),
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.from(stored);

  @override
  Future<Task> createTask(String title) async => stored.first;

  @override
  Future<Task> updateTask(String id, {String? title, bool? completed}) async =>
      stored.first;

  @override
  Future<void> deleteTask(String id) async {}

  @override
  Future<void> clearCompletedTasks() async {}
}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets(
      'should render Header, Task Input, Segmented control, and Task items',
      (tester) async {
        final authRepo = StubAuthRepo();
        final taskRepo = StubTaskRepo();

        final authCtrl = AuthController(authRepository: authRepo);
        final taskCtrl = TaskController(taskRepository: taskRepo);

        await tester.pumpWidget(
          MaterialApp(
            home: HomeScreen(
              authController: authCtrl,
              taskController: taskCtrl,
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('My Tasks'), findsOneWidget);
        expect(find.text('First Home Task'), findsOneWidget);
        expect(find.text('Add a new task...'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Active'), findsOneWidget);
        expect(find.text('Completed'), findsOneWidget);
      },
    );
  });
}
