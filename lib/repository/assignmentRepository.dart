import '../models/assignmentModel.dart';
import '../service/assignmentService.dart';
import 'package:alp_depd_flutter/main.dart';

class AssignmentRepository {
  final AssignmentService _service = AssignmentService();

  Future<List<Assignment>> getAssignments() async {
    final data = await _service.fetchAssignmentsRaw();
    return data.map((json) => Assignment.fromMap(json)).toList();
  }

  Future<void> saveAssignment(String title, String desc, DateTime due) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await _service.createAssignmentRaw({
      'user_id': user.id,
      'title': title,
      'description': desc,
      'progress': 0.0,
      'due_date': due.toIso8601String(),
    });
  }

  Future<void> updateBulkProgress(Map<String, double> updates) async {
    for (var entry in updates.entries) {
      await _service.updateAssignmentProgressRaw(entry.key, entry.value);
    }
  }
}
