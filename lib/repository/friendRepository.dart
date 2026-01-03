import 'package:alp_depd_flutter/model/model.dart';
import 'package:alp_depd_flutter/service/friendService.dart';
import 'package:alp_depd_flutter/main.dart';

class FriendRepository {
  final FriendService _service = FriendService();

  Future<List<UserModel>> getUsers() async {
    try {
      // 1. Get the current authenticated user's ID
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return [];

      // 2. Fetch only assignments belonging to this user
      final response = await _service.fetchUsersRaw();

      response.removeWhere((user) => user['id'] == userId);

      for (var user in response) {
        bool friendStatus = await _service.isFriend(user['id']);
        user['is_friend'] = friendStatus;
      }

      return (response as List).map((data) => UserModel.fromMap(data)).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  Future<List<FriendModel>> getFriendRequests() async {
    try {
      // 1. Get the current authenticated user's ID
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return [];

      // 2. Fetch only assignments belonging to this user
      final response = await _service.fetchFriendRequestsRaw();

      // 3. Map the response to your Model
      return (response as List)
          .map((data) => FriendModel.fromMap(data))
          .toList();
    } catch (e) {
      print("Error fetching friend requests: $e");
      return [];
    }
  }

  Future<List<ProfileModel>> getFriends() async {
    try {
      // 1. Get the current authenticated user's ID
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return [];

      final response = await _service.fetchFriendsRaw();

      // 3. Map the response to your Model
      return (response as List)
          .map((data) => ProfileModel.fromMap(data))
          .toList();
    } catch (e) {
      print("Error fetching friends: $e");
      return [];
    }
  }

  Future<void> addFriendRequest(String uid2) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await _service.createFriendRequestRaw({
      'user1_id': user.id,
      'user2_id': uid2,
    });
  }

  Future<void> acceptFriendRequest(int id) async {
    await _service.acceptFriendRequest(id);
  }

  Future<void> rejectFriendRequest(int id) async {
    await _service.rejectFriendRequest(id);
  }
}
