part of 'shared.dart';

class Const {
  static String get supabaseUrl {
    try {
      return dotenv.env['SUPABASE_URL'] ?? '';
    } catch (_) {
      return '';
    }
  }

  static String get supabaseAnonKey {
    try {
      return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    } catch (_) {
      return '';
    }
  }

  static String get restUrl => '${supabaseUrl}rest/v1/';
}
