/// Application configuration constants.
/// Centralizes backend URL, anon key, redirect schemes, and timeouts.
abstract final class AppConfig {
  /// Supabase project URL shared with Next.js web application.
  static const String supabaseUrl = 'https://ygincfhiaxhfjbvictgu.supabase.co';

  /// Supabase public anonymous key (safe to include in client application).
  static const String supabaseAnonKey =
      'sb_publishable_Ex8-tdeMvLECQwOXmfBqmw_sxUGKLx9';

  /// Google OAuth Web Client ID.
  /// Used by native Android Google Sign-In.
  static const String googleWebClientId =
      '923963730456-msd5raa4982ubkiuiikjtoeo4grvo60p.apps.googleusercontent.com';

  /// Custom Deep Link scheme and host for Google OAuth redirect on Android.
  static const String googleRedirectUrl =
      'io.supabase.fluttertodo://login-callback';

  /// Network request timeout duration.
  static const Duration requestTimeout = Duration(seconds: 15);

  /// Table name in Supabase PostgreSQL database.
  static const String tasksTable = 'tasks';
}
