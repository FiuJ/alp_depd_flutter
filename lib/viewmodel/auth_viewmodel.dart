import 'package:alp_depd_flutter/model/model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final _supabase = Supabase.instance.client;

  // Sign Up (Register)
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // 1. Create Auth User
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw 'Registration failed. Please try again.';
      }

      // 2. Create Profile Entry (Manual insert to match your schema)
      final newProfile = ProfileModel(
        id: response.user!.id, // Link to Auth ID
        username: username,
        createdAt: DateTime.now(),
      );

      await _supabase.from('profiles').insert(newProfile.toMap());

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Sign In (Login)
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw 'Login failed.';
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Login Failed: ${e.toString()}'; // Simple error handling
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}