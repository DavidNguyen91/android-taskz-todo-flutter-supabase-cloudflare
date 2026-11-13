import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/app_exceptions.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Presentation state controller for Authentication.
/// Adheres to Dependency Inversion by depending on [IAuthRepository].
class AuthController extends ChangeNotifier {
  final IAuthRepository authRepository;
  StreamSubscription<AuthUser?>? _authSubscription;

  AuthUser? _user;
  bool _isLoading = true;
  String? _errorMessage;

  AuthController({required this.authRepository}) {
    _init();
  }

  AuthUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _user = authRepository.currentUser;
    _isLoading = false;

    _authSubscription = authRepository.authStateChanges.listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authRepository.signInWithGoogle(
        redirectTo: AppConfig.googleRedirectUrl,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Could not sign in with Google. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authRepository.signInWithPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Invalid email or password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authRepository.signUpWithPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Could not create account. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await authRepository.signOut();
      _user = null;
    } catch (e) {
      _errorMessage = 'Sign out error occurred.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
