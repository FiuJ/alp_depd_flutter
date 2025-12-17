import 'package:alp_depd_flutter/model/model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<JournalModel> _journals = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<JournalModel> get journals => _journals;

  Future<bool> submitJournal({
    required String title,
    required String content,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw 'User not logged in';
      }

      // Create model based on your 'journal' table
      final newJournal = JournalModel(
        userId: user.id,
        date: DateTime.now(), // Sets current date
        title: title,
        content: content,
      );

      // Insert into 'journal' table
      await Supabase.instance.client
          .from('journal') // Matches table name in screenshot
          .insert(newJournal.toMap());

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> fetchJournals() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'User not logged in';

      // Fetch from Supabase
      final List<dynamic> response = await Supabase.instance.client
          .from('journal')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: false); // Newest first

      // Convert to List<JournalModel>
      _journals = response.map((data) => JournalModel.fromMap(data)).toList();
      
    } catch (e) {
      _errorMessage = 'Failed to load journals: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}