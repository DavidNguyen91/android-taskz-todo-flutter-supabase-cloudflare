import '../models/auth_user.dart';

/// Abstract contract for user authentication operations.
abstract interface class IAuthRepository {
  /// Stream of authentication state changes.
  Stream<AuthUser?> get authStateChanges;

  /// Gets the currently authenticated user, or null if none.
  AuthUser? get currentUser;

  /// Signs in with Google using native Android authentication.
  Future<void> signInWithGoogle();

  /// Signs in with Email and Password.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  /// Signs up with Email and Password.
  Future<void> signUpWithPassword({
    required String email,
    required String password,
  });

  /// Terminates the current session and clears persisted tokens.
  Future<void> signOut();
}
