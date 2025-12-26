// viewmodel/assignmentViewModel.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/assignment_repository.dart';

class AssignmentViewModel with ChangeNotifier {
  final AssignmentRepository _repo = AssignmentRepository();
  bool _isLoading = false;

  // ADD THESE TWO LINES:
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  Future<void> saveAssignment({
    required String title,
    required String description,
    required DateTime dueDate,
    required VoidCallback onSuccess,
  }) async {
    if (title.isEmpty) {
      _errorMessage = "Title cannot be empty";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null; // Reset error before starting
    notifyListeners();

    try {
      // Get current user_id from the global supabase client
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId != null) {
        await _repo.saveAssignment(title, description, dueDate);
        onSuccess(); // Triggers the green SnackBar and Navigator.pop
      } else {
        throw "User session expired. Please login again.";
      }
    } catch (e) {
      // CAPTURE THE ERROR MESSAGE HERE
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
