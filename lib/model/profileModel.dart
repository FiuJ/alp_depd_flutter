part of 'model.dart';

class ProfileModel {
  final String id;
  final String username;
  final String studentId;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.studentId,
  });

  // Convert to Map for Supabase insert
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Matches your schema (uuid)
      'username': username, // Matches your schema (varchar)
      'student_id': studentId, // Matches your schema (varchar)
      'created_at': createdAt.toIso8601String(), // Matches your schema
    };
  }

  // Create from Map (when fetching)
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      username: map['username'],
      studentId: map['student_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
