// viewmodel/assignmentViewModel.dart
import 'package:alp_depd_flutter/repository/friendRepository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsViewModel with ChangeNotifier {
  final FriendRepository _repo = FriendRepository();
  bool _isLoading = false;

  // ADD THESE TWO LINES:
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  Future<void> sendFriendRequest({
    required String uid,
    required VoidCallback onSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = null; // Reset error before starting
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId != null) {
        await _repo.addFriendRequest(uid);
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


  Future<void> acceptFriendRequest(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.acceptFriendRequest(id);
    } catch (e) {
      print("Error accepting friend request: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rejectFriendRequest(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.rejectFriendRequest(id);
    } catch (e) {
      print("Error rejecting friend request: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
