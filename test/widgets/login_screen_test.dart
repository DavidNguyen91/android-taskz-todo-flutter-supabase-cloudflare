import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/auth_user.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/repositories/auth_repository.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/controllers/auth_controller.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/screens/login_screen.dart';

class DummyAuthRepository implements IAuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  AuthUser? get currentUser => null;

  @override
  Future<void> signInWithGoogle({required String redirectTo}) async {}

  @override
  Future<void> signInWithPassword({required String email, required String password}) async {}

  @override
  Future<void> signUpWithPassword({required String email, required String password}) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should render Google Sign-In, Email, Password fields and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final repo = DummyAuthRepository();
      final controller = AuthController(authRepository: repo);

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(authController: controller),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text("Don't have an account? Sign up"), findsOneWidget);

      // Toggle to Sign Up mode
      final switchBtn = find.text("Don't have an account? Sign up");
      await tester.ensureVisible(switchBtn);
      await tester.tap(switchBtn);
      await tester.pumpAndSettle();

      expect(find.text('Create an account'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Already have an account? Sign in'), findsOneWidget);
    });
  });
}
