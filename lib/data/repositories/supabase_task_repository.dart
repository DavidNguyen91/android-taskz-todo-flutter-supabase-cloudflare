import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../dto/task_dto.dart';

/// Concrete implementation of [ITaskRepository] backed by Supabase.
/// Decoupled via constructor injection for testability and maintainability.
class SupabaseTaskRepository implements ITaskRepository {
  final SupabaseClient client;

  const SupabaseTaskRepository({required this.client});

  @override
  Future<List<Task>> getTasks() async {
    return _guard(() async {
      final response = await client
          .from(AppConfig.tasksTable)
          .select('id, title, completed, created_at, updated_at')
          .order('created_at', ascending: false)
          .timeout(AppConfig.requestTimeout);

      final list = response as List<dynamic>;
      return list
          .map((row) => TaskDto.fromJson(row as Map<String, dynamic>).toEntity())
          .toList();
    });
  }

  @override
  Future<Task> createTask(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException('Task title cannot be empty');
    }
    if (trimmed.length > 300) {
      throw const ValidationException('Task title cannot exceed 300 characters');
    }

    return _guard(() async {
      final now = DateTime.now().toUtc();
      final response = await client
          .from(AppConfig.tasksTable)
          .insert({
            'title': trimmed,
            'completed': false,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select('id, title, completed, created_at, updated_at')
          .single()
          .timeout(AppConfig.requestTimeout);

      return TaskDto.fromJson(response).toEntity();
    });
  }

  @override
  Future<Task> updateTask(
    String id, {
    String? title,
    bool? completed,
  }) async {
    final now = DateTime.now().toUtc();
    final payload = <String, dynamic>{
      'updated_at': now.toIso8601String(),
    };

    if (title != null) {
      final trimmed = title.trim();
      if (trimmed.isEmpty) {
        throw const ValidationException('Task title cannot be empty');
      }
      if (trimmed.length > 300) {
        throw const ValidationException('Task title cannot exceed 300 characters');
      }
      payload['title'] = trimmed;
    }

    if (completed != null) {
      payload['completed'] = completed;
    }

    return _guard(() async {
      final response = await client
          .from(AppConfig.tasksTable)
          .update(payload)
          .eq('id', id)
          .select('id, title, completed, created_at, updated_at')
          .single()
          .timeout(AppConfig.requestTimeout);

      return TaskDto.fromJson(response).toEntity();
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    await _guard(() async {
      await client
          .from(AppConfig.tasksTable)
          .delete()
          .eq('id', id)
          .timeout(AppConfig.requestTimeout);
    });
  }

  @override
  Future<void> clearCompletedTasks() async {
    await _guard(() async {
      await client
          .from(AppConfig.tasksTable)
          .delete()
          .eq('completed', true)
          .timeout(AppConfig.requestTimeout);
    });
  }

  /// Catches low-level SDK and system errors, transforming them into typed [AppException]s.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SocketException catch (e) {
      throw NetworkException('No internet connection. Please verify your network.', e);
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out. Please try again.', e);
    } on AuthException catch (e) {
      throw UnauthorizedException(e.message, e);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST301' || e.code == '401' || e.message.contains('JWT')) {
        throw UnauthorizedException('Authentication expired. Please sign in again.', e);
      }
      throw ServerException(e.message, e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('An unexpected error occurred.', e);
    }
  }
}
