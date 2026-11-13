import 'package:flutter/foundation.dart';

/// Immutable Domain Entity representing an authenticated user.
@immutable
class AuthUser {
  final String id;
  final String? email;

  const AuthUser({
    required this.id,
    this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'AuthUser(id: $id, email: $email)';
}
