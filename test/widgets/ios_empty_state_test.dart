import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/widgets/ios_empty_state.dart';

void main() {
  group('IosEmptyState Widget Tests', () {
    testWidgets('should render No Tasks Yet when total tasks == 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IosEmptyState(
              filter: TaskFilter.all,
              hasAnyTasks: false,
            ),
          ),
        ),
      );

      expect(find.text('No Tasks Yet'), findsOneWidget);
      expect(
        find.text('Type a task in the field above to organize your goals and daily to-dos.'),
        findsOneWidget,
      );
    });

    testWidgets('should render All Caught Up when active tasks empty in active filter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IosEmptyState(
              filter: TaskFilter.active,
              hasAnyTasks: true,
            ),
          ),
        ),
      );

      expect(find.text('All Caught Up'), findsOneWidget);
      expect(
        find.text('You have finished all active tasks. Take a break or add a new one.'),
        findsOneWidget,
      );
    });

    testWidgets('should render No Completed Tasks in completed filter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IosEmptyState(
              filter: TaskFilter.completed,
              hasAnyTasks: true,
            ),
          ),
        ),
      );

      expect(find.text('No Completed Tasks'), findsOneWidget);
      expect(
        find.text('Tasks you check off will appear here for easy reference.'),
        findsOneWidget,
      );
    });
  });
}
