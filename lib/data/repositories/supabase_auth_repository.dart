import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import '../../core/config/app_config.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Concrete implementation of [IAuthRepository] using Supabase GoTrue Auth.
class SupabaseAuthRepository implements IAuthRepository {
  final SupabaseClient client;

  const SupabaseAuthRepository({required this.client});

  @override
  Stream<AuthUser?> get authStateChanges {
    return client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return AuthUser(id: user.id, email: user.email);
    });
  }

  @override
  AuthUser? get currentUser {
    final user = client.auth.currentUser;
    if (user == null) return null;
    return AuthUser(id: user.id, email: user.email);
  }

  @override
  Future<void> signInWithGoogle({required String redirectTo}) async {
    await _guard(() async {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectTo,
      );
    });
  }

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw const ValidationException('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw const ValidationException('Password cannot be empty');
    }

    await _guard(() async {
      await client.auth
          .signInWithPassword(
            email: trimmedEmail,
            password: password,
          )
          .timeout(AppConfig.requestTimeout);
    });
  }

  @override
  Future<void> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw const ValidationException('Email cannot be empty');
    }
    if (password.length < 6) {
      throw const ValidationException('Password must be at least 6 characters');
    }

    await _guard(() async {
      await client.auth
          .signUp(
            email: trimmedEmail,
            password: password,
          )
          .timeout(AppConfig.requestTimeout);
    });
  }

  @override
  Future<void> signOut() async {
    await _guard(() async {
      await client.auth.signOut().timeout(AppConfig.requestTimeout);
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SocketException catch (e) {
      throw NetworkException('No internet connection.', e);
    } on TimeoutException catch (e) {
      throw NetworkException('Request timed out. Please try again.', e);
    } on AuthException catch (e) {
      throw UnauthorizedException(e.message, e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Authentication failed.', e);
    }
  }
}
