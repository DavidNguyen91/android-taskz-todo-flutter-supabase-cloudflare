import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/widgets/ios_task_input.dart';

void main() {
  group('IosTaskInput Widget Tests', () {
    testWidgets('submit button should be disabled when text is empty or whitespace', (tester) async {
      var addCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosTaskInput(
              onAddTask: (title) async {
                addCalled = true;
                return true;
              },
            ),
          ),
        ),
      );

      // Initially empty -> tap submit
      await tester.tap(find.byType(CupertinoButton));
      await tester.pump();
      expect(addCalled, isFalse);

      // Type whitespace -> tap submit
      await tester.enterText(find.byType(CupertinoTextField), '    ');
      await tester.pump();
      await tester.tap(find.byType(CupertinoButton));
      await tester.pump();
      expect(addCalled, isFalse);
    });

    testWidgets('submit button should submit valid text and clear input field', (tester) async {
      String? submittedTitle;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IosTaskInput(
              onAddTask: (title) async {
                submittedTitle = title;
                return true;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(CupertinoTextField), 'Buy fresh bread');
      await tester.pump();

      await tester.tap(find.byType(CupertinoButton));
      await tester.pump();

      expect(submittedTitle, 'Buy fresh bread');
      expect(find.text('Buy fresh bread'), findsNothing); // cleared
    });
  });
}
