// Removed `dart:ffi` import — not available on web and not used here.

import '../model/assignment_model.dart';
import '../service/friends_service.dart';
import 'package:alp_depd_flutter/main.dart';

class FriendsRepository {
  final FriendsService _service = FriendsService();

  Future<List<Assignment>> getFriends() async {
    try {
      // 1. Get the current authenticated user's ID
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return [];

      // 2. Fetch only assignments belonging to this user
      final response = await _service.fetchFriendsRaw();

      // 3. Map the response to your Model
      return (response as List)
          .map((data) => Assignment.fromMap(data))
          .toList();
    } catch (e) {
      print("Error fetching assignments: $e");
      return [];
    }
  }

  Future<void> addFriend(String username) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await _service.addFriend({'confirmed': false, 'username': username});
  }

  Future<void> acceptFriendRequest(String username) async {
    await _service.acceptFriendRequest(username);
  }

  Future<void> rejectFriendRequest(String username) async {
    await _service.rejectFriendRequest(username);
  }

  Future<void> removeFriend(String username) async {
    await _service.removeFriend(username);
  }

  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await _service.fetchFriendRequestsRaw();
  }

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    return await _service.fetchAllUsersRaw();
  }
}
