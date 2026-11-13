import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/data/dto/task_dto.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';

void main() {
  group('TaskDto JSON Mapping Tests', () {
    test('should parse from JSON map correctly with UTC timezone preservation', () {
      final jsonMap = {
        'id': 'd3b07384-d113-494b-9c8e-0123456789ab',
        'title': 'Test Playwright synchronization',
        'completed': true,
        'created_at': '2026-11-13T10:30:00.000Z',
        'updated_at': '2026-11-13T10:45:00.000Z',
      };

      final dto = TaskDto.fromJson(jsonMap);

      expect(dto.id, 'd3b07384-d113-494b-9c8e-0123456789ab');
      expect(dto.title, 'Test Playwright synchronization');
      expect(dto.completed, isTrue);
      expect(dto.createdAt, DateTime.utc(2026, 11, 13, 10, 30, 0));
      expect(dto.updatedAt, DateTime.utc(2026, 11, 13, 10, 45, 0));
    });

    test('should serialize to JSON map matching Supabase columns', () {
      final dto = TaskDto(
        id: 'uuid-1',
        title: 'Complete homework',
        completed: false,
        createdAt: DateTime.utc(2026, 11, 13, 12, 0, 0),
        updatedAt: DateTime.utc(2026, 11, 13, 12, 0, 0),
      );

      final json = dto.toJson();

      expect(json['id'], 'uuid-1');
      expect(json['title'], 'Complete homework');
      expect(json['completed'], isFalse);
      expect(json['created_at'], '2026-11-13T12:00:00.000Z');
      expect(json['updated_at'], '2026-11-13T12:00:00.000Z');
    });

    test('should bi-directionally convert to/from Domain Entity', () {
      final entity = Task(
        id: 'entity-1',
        title: 'Review PR',
        completed: true,
        createdAt: DateTime.utc(2026, 11, 13, 15, 0, 0),
        updatedAt: DateTime.utc(2026, 11, 13, 15, 30, 0),
      );

      final dto = TaskDto.fromEntity(entity);
      final convertedBack = dto.toEntity();

      expect(convertedBack, equals(entity));
    });
  });
}
