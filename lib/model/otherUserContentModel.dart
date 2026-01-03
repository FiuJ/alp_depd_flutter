part of 'model.dart';

class OtherJournalModel {
  final String title;
  final String content;
  final String date;

  OtherJournalModel({
    required this.title,
    required this.content,
    required this.date,
  });

  factory OtherJournalModel.fromJson(Map<String, dynamic> json) {
    return OtherJournalModel(
      title: json['title'] ?? 'No Title',
      content: json['content'] ?? '',
      date: json['created_at'] ?? '', // Sesuaikan nama kolom di Supabase
    );
  }
}

class OtherAssignmentModel {
  final String title;
  final int progress;

  OtherAssignmentModel({required this.title, required this.progress});
  factory OtherAssignmentModel.fromJson(Map<String, dynamic> json) {
    return OtherAssignmentModel(
      title: json['title'] ?? 'Task', // Sesuaikan nama kolom
      progress: json['progress'] ?? 0,
    );
  }
}
