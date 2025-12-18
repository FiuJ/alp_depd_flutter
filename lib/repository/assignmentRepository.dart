// Removed `dart:ffi` import — not available on web and not used here.

import '../model/assignmentModel.dart';
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
          .eq('user_id', userId) // Ensure this column name matches your DB
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
}
