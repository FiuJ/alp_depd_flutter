part of 'shared.dart';
class Const {
  static String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  static String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? "";
  static String get restUrl => '$supabaseUrl/rest/v1/';
}