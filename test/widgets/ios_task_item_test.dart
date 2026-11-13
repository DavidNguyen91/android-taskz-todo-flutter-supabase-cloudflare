import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/widgets/ios_task_item.dart';

void main() {
  group('IosTaskItem Widget Tests', () {
    final now = DateTime.utc(2026, 11, 13);

    testWidgets('should render active task title without strikethrough', (tester) async {
      final task = Task(
        id: '1',
        title: 'Active Task Test',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosTaskItem(
              task: task,
              onToggle: (_) {},
              onEdit: (_, _) async => true,
              onDelete: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Active Task Test'), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text('Active Task Test'));
      expect(textWidget.style?.decoration, isNot(TextDecoration.lineThrough));
    });

    testWidgets('should render completed task title with lineThrough strikethrough', (tester) async {
      final task = Task(
        id: '1',
        title: 'Completed Task Test',
        completed: true,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosTaskItem(
              task: task,
              onToggle: (_) {},
              onEdit: (_, _) async => true,
              onDelete: (_) {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Completed Task Test'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('tapping checkbox should invoke onToggle callback', (tester) async {
      String? toggledId;
      final task = Task(
        id: 'task-99',
        title: 'Toggleable Task',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosTaskItem(
              task: task,
              onToggle: (id) => toggledId = id,
              onEdit: (_, _) async => true,
              onDelete: (_) {},
            ),
          ),
        ),
      );

      // Tap on the checkbox container
      await tester.tap(find.bySemanticsLabel('Mark complete'));
      await tester.pump();

      expect(toggledId, 'task-99');
    });
  });
}
