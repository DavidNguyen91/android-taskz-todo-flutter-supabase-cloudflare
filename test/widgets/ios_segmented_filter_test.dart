import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/task.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/widgets/ios_segmented_filter.dart';

void main() {
  group('IosSegmentedFilter Widget Tests', () {
    testWidgets('should render All, Active, Completed labels with counts', (tester) async {
      const counts = TaskCounts(total: 5, active: 3, completed: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosSegmentedFilter(
              currentFilter: TaskFilter.all,
              counts: counts,
              onFilterChanged: (_) {},
              onClearCompleted: () {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);

      expect(find.text('5'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      // "Clear completed" button should be visible since completed > 0
      expect(find.text('Clear completed'), findsOneWidget);
    });

    testWidgets('Clear completed button should be hidden when completed count is 0', (tester) async {
      const counts = TaskCounts(total: 3, active: 3, completed: 0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosSegmentedFilter(
              currentFilter: TaskFilter.all,
              counts: counts,
              onFilterChanged: (_) {},
              onClearCompleted: () {},
            ),
          ),
        ),
      );

      expect(find.text('Clear completed'), findsNothing);
    });
  });
}
