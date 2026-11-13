/// Base class for all domain and data exceptions in the application.
abstract class AppException implements Exception {
  final String message;
  final Object? cause;

  const AppException(this.message, [this.cause]);

  @override
  String toString() => message;
}

/// Thrown when there is no network connection or a request times out.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network connection error. Please check your internet.',
    super.cause,
  ]);
}

/// Thrown when an unauthenticated user attempts an operation or session expires.
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Session expired. Please sign in again.',
    super.cause,
  ]);
}

/// Thrown when input data fails client or server validation rules.
class ValidationException extends AppException {
  const ValidationException(super.message, [super.cause]);
}

/// Thrown when backend returns a server-side error.
class ServerException extends AppException {
  const ServerException([
    super.message = 'Server error occurred. Please try again later.',
    super.cause,
  ]);
}
