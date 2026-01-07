import 'package:alp_depd_flutter/model/model.dart';

import '../service/assignmentService.dart';
import 'package:alp_depd_flutter/main.dart';

class AssignmentRepository {
  final AssignmentService _service = AssignmentService();

  Future<List<Assignment>> getAssignments() async {
    try {
      // 1. Get the current authenticated user's ID
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return [];

      // 2. Fetch only assignments belonging to this user
      final response = await supabase
          .from('assignments')
          .select()
          .eq('user_id', userId)
          .lt('progress', 100)
          .order('due_date', ascending: true);

      // 3. Map the response to your Model
      return (response as List)
          .map((data) => Assignment.fromMap(data))
          .toList();
    } catch (e) {
      print("Error fetching assignments: $e");
      return [];
    }
  }

  Future<void> saveAssignment(String title, String desc, DateTime due) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await _service.createAssignmentRaw({
      'user_id': user.id,
      'title': title,
      'description': desc,
      'progress': 0,
      'due_date': due.toIso8601String(),
    });
  }

  Future<void> updateBulkProgress(Map<String, int> updates) async {
    for (var entry in updates.entries) {
      await _service.updateAssignmentProgressRaw(entry.key, entry.value);
    }
  }

  Future<int> getWeeklyCompletedTasksCount() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return 0;

    // Calculate start of week (Monday) at 00:00:00
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startSnapshot = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    try {
      final response = await supabase
          .from('assignments')
          .select('id') // We only need the ID to count rows
          .eq('user_id', userId)
          .eq('progress', 100)
          // Use .gte with a clean ISO8601 string
          .gte('due_date', startSnapshot.toIso8601String());

      // Explicitly treat the response as a List to get the length
      if (response is List) {
        return response.length;
      }
      return 0;
    } catch (e) {
      print("Error counting completed tasks: $e");
      return 0;
    }
  }
}
