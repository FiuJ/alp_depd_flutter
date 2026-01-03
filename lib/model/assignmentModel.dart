part of 'model.dart';

class Assignment {
  final String id;
  final String userId;
  final String title;
  final String description;
  final int progress;
  final DateTime dueDate;

  Assignment({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.progress,
    required this.dueDate,
  });

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      // Use .toString() to prevent the int-to-String subtype error
      id: map['id'].toString(),
      userId: map['user_id'].toString(),

      title: map['title'] ?? '',
      description: map['description'] ?? '',

      // Explicitly cast to int to ensure it matches your class property
      progress: (map['progress'] as num?)?.toInt() ?? 0,

      dueDate: DateTime.parse(map['due_date']),
    );
  }
}
