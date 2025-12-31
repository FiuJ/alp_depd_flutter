class JournalModel {
  final String title;
  final String content;
  final String date;

  JournalModel({required this.title, required this.content, required this.date});

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      title: json['title'] ?? 'No Title',
      content: json['content'] ?? '',
      date: json['created_at'] ?? '', // Sesuaikan nama kolom di Supabase
    );
  }
}

class AssignmentModel {
  final String taskName;
  final bool isCompleted;

  AssignmentModel({required this.taskName, required this.isCompleted});

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      taskName: json['task_name'] ?? 'Task', // Sesuaikan nama kolom
      isCompleted: json['status'] == 'completed' || json['is_completed'] == true,
    );
  }
}