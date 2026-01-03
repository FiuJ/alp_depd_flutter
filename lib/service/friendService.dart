// Use the global `supabase` client from main.dart
import 'package:alp_depd_flutter/main.dart'; // Import your main.dart to access global 'supabase'

class FriendService {
  // Uses the global 'supabase' variable from your main.dart

  Future<List<Map<String, dynamic>>> fetchUsersRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final relatedIds = await _fetchRelatedUserIds(user.id);

    // Always exclude yourself
    relatedIds.add(user.id);

    final response = await supabase
        .from('profiles')
        .select()
        .not('id', 'in', '(${relatedIds.map((e) => '"$e"').join(',')})');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<String>> _fetchRelatedUserIds(String myId) async {
    final res = await supabase
        .from('friends')
        .select('user1_id, user2_id')
        .or('user1_id.eq.$myId,user2_id.eq.$myId');

    final data = res as List<dynamic>;

    final relatedIds = <String>{};

    for (final row in data) {
      if (row['user1_id'] != myId) {
        relatedIds.add(row['user1_id']);
      }
      if (row['user2_id'] != myId) {
        relatedIds.add(row['user2_id']);
      }
    }

    return relatedIds.toList();
  }

  Future<bool> isFriend(String uid2) async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    // Check both directions: (current -> other) OR (other -> current)
    final response = await supabase
        .from('friends')
        .select()
        .or(
          'and(user1_id.eq.${user.id},user2_id.eq.$uid2),and(user1_id.eq.$uid2,user2_id.eq.${user.id})',
        )
        .eq('confirmed', true);

    return (response as List).isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchFriendsRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    // Include both user profiles so we can pick the "other" user's username
    final response = await supabase
        .from('friends')
        .select('''
          id,
          user1_id,
          user2_id,
          confirmed,
          created_at,
          user1:profiles!friends_user1_id_fkey(id, username, student_id),
          user2:profiles!friends_user2_id_fkey(id, username, student_id)
          ''')
        .or('user1_id.eq.${user.id},user2_id.eq.${user.id}')
        .eq('confirmed', true);

    final List rows = response as List? ?? [];
    return rows.map<Map<String, dynamic>>((row) {
      final user1 = (row['user1'] is Map) ? row['user1'] : {};
      final user2 = (row['user2'] is Map) ? row['user2'] : {};

      final otherUsername = (row['user1_id'] == user.id)
          ? (user2['username'] ?? '')
          : (user1['username'] ?? '');

      final otherStudentId = (row['user1_id'] == user.id)
          ? (user2['student_id'] ?? '')
          : (user1['student_id'] ?? '');

      final bool amUser1 = row['user1_id'] == user.id;
      final otherUser = amUser1 ? user2 : user1;

      return {
        'id': otherUser['id'],
        'username': otherUsername,
        'student_id': otherStudentId,
        'created_at': row['created_at'],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchFriendRequestsRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    // Select friend request rows and include sender profile (user1) username.
    // The alias `user1:profiles(username)` tells PostgREST to include the
    // related profile for the `user1_id` foreign key.
    final response = await supabase
        .from('friends')
        .select(
          'id, user1_id, user2_id, confirmed, created_at, user1:profiles(username)',
        )
        .eq('user2_id', user.id)
        .eq('confirmed', false);

    // Normalize response to the shape expected by FriendModel.fromMap
    // (id, username, created_at) so higher layers don't need to change.
    final List rows = response as List? ?? [];
    return rows.map<Map<String, dynamic>>((row) {
      final sender = (row['user1'] is Map) ? row['user1'] : {};
      return {
        'id': row['id'],
        'username': sender['username'] ?? '',
        'created_at': row['created_at'],
      };
    }).toList();
  }

  Future<void> createFriendRequestRaw(Map<String, dynamic> data) async {
    await supabase.from('friends').insert(data);
  }

  Future<void> acceptFriendRequest(int id) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('friends').update({'confirmed': true}).eq('id', id);
  }

  Future<void> rejectFriendRequest(int id) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('friends').delete().eq('id', id);
  }
}
