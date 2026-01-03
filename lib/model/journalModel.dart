
part of 'model.dart';

class JournalModel {
  final int? journalId; // Matches 'journal_id' (int8)
  final String userId;  // Matches 'user_id' (uuid)
  final DateTime date;  // Matches 'date' (date)
  final String title;   // Matches 'title' (varchar)
  final String content; // Matches 'content' (text)

  JournalModel({
    this.journalId,
    required this.userId,
    required this.date,
    required this.title,
    required this.content,
  });

  // Convert to Map for Supabase insert
  Map<String, dynamic> toMap() {
    return {
      // We don't send 'journal_id' because it is auto-incrementing (int8)
      'user_id': userId,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
    };
  }

  // Create from Map (fetching from Supabase)
  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      journalId: map['journal_id'],
      userId: map['user_id'],
      date: DateTime.parse(map['date']),
      title: map['title'],
      content: map['content'],
    );
  }
}