part of 'model.dart';

class StressModel {
  final String? id;
  final String userId;
  final int? assignmentId; // Menggunakan int? untuk relasi ke BIGINT
  final int q1Vas, q2Mental, q3Physical, q4Temporal, q5Performance, q6Effort, q7Frustration;
  final double totalPercentage;
  final DateTime createdAt;

  StressModel({
    this.id,
    required this.userId,
    this.assignmentId,
    required this.q1Vas,
    required this.q2Mental,
    required this.q3Physical,
    required this.q4Temporal,
    required this.q5Performance,
    required this.q6Effort,
    required this.q7Frustration,
    required this.totalPercentage,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'assignment_id': assignmentId,
    'q1_vas': q1Vas,
    'q2_mental': q2Mental,
    'q3_physical': q3Physical,
    'q4_temporal': q4Temporal,
    'q5_performance': q5Performance,
    'q6_effort': q6Effort,
    'q7_frustration': q7Frustration,
    'total_percentage': totalPercentage,
    'created_at': createdAt.toIso8601String(),
  };

  factory StressModel.fromJson(Map<String, dynamic> json) => StressModel(
    id: json['id'].toString(),
    userId: json['user_id'],
    assignmentId: json['assignment_id'] != null ? json['assignment_id'] as int : null,
    q1Vas: json['q1_vas'],
    q2Mental: json['q2_mental'],
    q3Physical: json['q3_physical'],
    q4Temporal: json['q4_temporal'],
    q5Performance: json['q5_performance'],
    q6Effort: json['q6_effort'],
    q7Frustration: json['q7_frustration'],
    totalPercentage: (json['total_percentage'] as num).toDouble(),
    createdAt: DateTime.parse(json['created_at']),
  );
}