// import 'package:alp_depd_flutter/main.dart';
import 'package:alp_depd_flutter/main.dart';
import 'package:alp_depd_flutter/model/model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:alp_depd_flutter/model/profile_model.dart';

class AuthViewModel extends ChangeNotifier {
  // Do not access Supabase.instance at construction time; it may not be
  // initialized (we run without initialization for web in some flows).
  // Instead, access the client inside methods and handle the case where
  // Supabase has not been initialized yet.

  bool _isLoading = false;
  String? _errorMessage;
  ProfileModel? _currentUserProfile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ProfileModel? get currentUserProfile => _currentUserProfile;

  // Sign Up (Register)
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    required String studentId,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final client = supabase;

      // 1. Create Auth User
      final AuthResponse response = await client.auth.signUp(
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
        studentId: studentId,
        createdAt: DateTime.now(),
      );

      await client.from('profiles').insert(newProfile.toMap());

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<ProfileModel?> fetchCurrentUserProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return ProfileModel.fromMap(response);
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      return null;
    }
  }

  // Sign In (Login)
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final client = supabase;

      final AuthResponse response = await client.auth.signInWithPassword(
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
    try {
      final client = supabase;
      await client.auth.signOut();
    } catch (_) {
      // Supabase not initialized — nothing to do
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
