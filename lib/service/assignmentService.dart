import 'package:alp_depd_flutter/main.dart'; // Import your main.dart to access global 'supabase'

class AssignmentService {
  // Uses the global 'supabase' variable from your main.dart

  Future<List<Map<String, dynamic>>> fetchAssignmentsRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await supabase
        .from('assignments')
        .select()
        .eq('user_id', user.id)
        .order('due_date', ascending: true);
  }

  Future<void> createAssignmentRaw(Map<String, dynamic> data) async {
    await supabase.from('assignments').insert(data);
  }

  Future<void> updateAssignmentProgressRaw(String id, double progress) async {
    await supabase
        .from('assignments')
        .update({'progress': progress})
        .eq('id', id);
  }
}
