// Removed `dart:ffi` import — not available on web and not used here.

import 'package:alp_depd_flutter/main.dart'; // Import your main.dart to access global 'supabase'

class FriendsService {
  // Uses the global 'supabase' variable from your main.dart

  Future<List<Map<String, dynamic>>> fetchFriendsRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await supabase
        .from('friends')
        .select()
        .eq('user1_id', user.id)
        .eq('confirmed', true);
  }

  Future<void> addFriend(Map<String, dynamic> data) async {
    await supabase.from('assignments').insert(data);
  }

  Future<void> acceptFriendRequest(String username) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final friendRecord = await supabase
        .from('profiles')
        .select('username')
        .maybeSingle();

    if (friendRecord == null) return;

    await supabase
        .from('friends')
        .update({'confirmed': true})
        .eq('user1_id', user.id)
        .eq('user2_id', friendRecord['id']);
  }

  Future<void> rejectFriendRequest(String username) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final friendRecord = await supabase
        .from('profiles')
        .select('username')
        .maybeSingle();

    if (friendRecord == null) return;

    await supabase
        .from('friends')
        .delete()
        .eq('user1_id', user.id)
        .eq('user2_id', friendRecord['id']);
  }

  Future<void> removeFriend(String username) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final friendRecord = await supabase
        .from('profiles')
        .select('username')
        .maybeSingle();

    if (friendRecord == null) return;

    await supabase
        .from('friends')
        .delete()
        .eq('user1_id', user.id)
        .eq('user2_id', friendRecord['id']);
  }

  Future<List<Map<String, dynamic>>> fetchFriendRequestsRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await supabase
        .from('friends')
        .select()
        .eq('user2_id', user.id)
        .eq('confirmed', false);
  }

  Future<List<Map<String, dynamic>>> fetchAllUsersRaw() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    return await supabase.from('profiles').select().neq('id', user.id);
  }
}
