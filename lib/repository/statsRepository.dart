import 'package:alp_depd_flutter/shared/supabase_client.dart';

class StatsRepository {
  // In StatsRepository
  Future<Map<String, int>> getWeeklyStats() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return {'focus': 0, 'rest': 0};

    final now = DateTime.now().toUtc();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfRange = DateTime.utc(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    try {
      final response = await supabase
          .from('timer_sessions')
          .select('type, duration_minutes')
          .eq('user_id', userId)
          .gte('created_at', startOfRange.toIso8601String());

      int focusTotal = 0;
      int restTotal = 0;

      if (response is List) {
        for (var row in response) {
          final type = row['type']?.toString().toLowerCase().trim();
          // Use 'as num' to safely handle both integers and doubles from Supabase
          final minutes = (row['duration_minutes'] as num?)?.toInt() ?? 0;

          if (type == 'focus') focusTotal += minutes;
          if (type == 'rest') restTotal += minutes;
        }
      }

      return {'focus': focusTotal, 'rest': restTotal};
    } catch (e) {
      print("Error fetching timer stats: $e");
      return {'focus': 0, 'rest': 0};
    }
  }
}
