part of 'model.dart';

class FriendModel {
  final int id;
  final String username;
  final DateTime createdAt;

  FriendModel({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  // Convert to Map for Supabase insert
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Matches your schema (uuid)
      'username': username, // Matches your schema (varchar)
      'created_at': createdAt.toIso8601String(), // Matches your schema
    };
  }

  // Create from Map (when fetching)
  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['id'],
      username: map['username'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
