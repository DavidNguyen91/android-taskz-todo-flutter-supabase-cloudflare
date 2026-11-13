import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_todo_flutter_cloudflare_supabase/core/errors/app_exceptions.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/models/auth_user.dart';
import 'package:android_todo_flutter_cloudflare_supabase/domain/repositories/auth_repository.dart';
import 'package:android_todo_flutter_cloudflare_supabase/presentation/controllers/auth_controller.dart';

class FakeAuthRepository implements IAuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();
  AuthUser? user;
  bool shouldThrow = false;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  AuthUser? get currentUser => user;

  @override
  Future<void> signInWithGoogle({required String redirectTo}) async {
    if (shouldThrow) throw const NetworkException('OAuth error');
    user = const AuthUser(id: 'google-user-1', email: 'user@google.com');
    _controller.add(user);
  }

  @override
  Future<void> signInWithPassword({required String email, required String password}) async {
    if (shouldThrow) throw const UnauthorizedException('Invalid credentials');
    user = AuthUser(id: 'email-user-1', email: email);
    _controller.add(user);
  }

  @override
  Future<void> signUpWithPassword({required String email, required String password}) async {
    if (shouldThrow) throw const ServerException('Signup failed');
    user = AuthUser(id: 'new-user-1', email: email);
    _controller.add(user);
  }

  @override
  Future<void> signOut() async {
    user = null;
    _controller.add(null);
  }
}

void main() {
  late FakeAuthRepository repository;
  late AuthController controller;

  setUp(() {
    repository = FakeAuthRepository();
    controller = AuthController(authRepository: repository);
  });

  tearDown(() {
    controller.dispose();
  });

  group('AuthController Unit Tests', () {
    test('initial state should reflect unauthenticated user', () {
      expect(controller.user, isNull);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, isNull);
    });

    test('signInWithPassword success should update state', () async {
      final success = await controller.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(success, isTrue);
      expect(controller.user?.email, 'test@example.com');
      expect(controller.isAuthenticated, isTrue);
      expect(controller.errorMessage, isNull);
    });

    test('signInWithPassword failure should capture error message', () async {
      repository.shouldThrow = true;
      final success = await controller.signInWithPassword(
        email: 'test@example.com',
        password: 'wrong',
      );

      expect(success, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, contains('Invalid credentials'));
    });

    test('signOut should clear user and authenticated status', () async {
      await controller.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      );
      expect(controller.isAuthenticated, isTrue);

      await controller.signOut();
      expect(controller.user, isNull);
      expect(controller.isAuthenticated, isFalse);
    });
  });
}
