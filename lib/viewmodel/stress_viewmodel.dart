import 'package:alp_depd_flutter/model/model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StressViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<StressModel> _stressHistory = [];
  List<StressModel> get stressHistory => _stressHistory;

  double calculateFinalScore(List<int> scores) {
    // scores[4] adalah Q5: Performance. Jika puas (5), stres rendah (poin 1).
    int q5Inverted = 6 - scores[4]; 
    int total = scores[0] + scores[1] + scores[2] + scores[3] + q5Inverted + scores[5] + scores[6];
    // Skala 1-5 untuk 7 tanya, min=7, max=35.
    return ((total - 7) / 28) * 100;
  }

  Future<bool> saveStressRecord(List<int> scores, int? assignmentId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final data = StressModel(
        userId: user.id,
        assignmentId: assignmentId,
        q1Vas: scores[0], q2Mental: scores[1], q3Physical: scores[2],
        q4Temporal: scores[3], q5Performance: scores[4],
        q6Effort: scores[5], q7Frustration: scores[6],
        totalPercentage: calculateFinalScore(scores),
        createdAt: DateTime.now(),
      );

      await _supabase.from('stresses').insert(data.toJson());
      return true;
    } catch (e) {
      debugPrint("Error saving stress: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase
        .from('stresses')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: true);

    _stressHistory = (response as List).map((e) => StressModel.fromJson(e)).toList();
    notifyListeners();
  }
}