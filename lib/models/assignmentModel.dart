class Assignment {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double progress;
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
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'] ?? '',
      progress: (map['progress'] ?? 0.0).toDouble(),
      dueDate: DateTime.parse(map['due_date']),
    );
  }
}
