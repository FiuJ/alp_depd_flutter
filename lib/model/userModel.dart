part of 'model.dart';

class UserModel {
  final String id;
  final String username;
  final DateTime createdAt;
  final bool alreadyFriend;

  UserModel({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.alreadyFriend,
  });

  // Convert to Map for Supabase insert
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Matches your schema (uuid)
      'username': username, // Matches your schema (varchar)
      'created_at': createdAt.toIso8601String(), // Matches your schema
      'already_friend': alreadyFriend,
    };
  }

  // Create from Map (when fetching)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      createdAt: DateTime.parse(map['created_at']),
      alreadyFriend: map['already_friend'] ?? false,
    );
  }
}
