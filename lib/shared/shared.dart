import 'package:supabase_flutter/supabase_flutter.dart'; // Add this import
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'const.dart';

// ADD THIS LINE - This is the permanent fix for the LateInitializationError
SupabaseClient get supabase => Supabase.instance.client;
