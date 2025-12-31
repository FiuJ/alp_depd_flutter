import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/userProfile_model.dart';
import '../view/pages/pages.dart'; // Pastikan path login page benar

class ProfileViewModel extends ChangeNotifier {
  static final ProfileViewModel instance = ProfileViewModel._internal();
  factory ProfileViewModel() => instance;
  ProfileViewModel._internal();

  UserModel _user = UserModel();
  UserModel get user => _user;

  final ImagePicker _picker = ImagePicker();
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- 1. LOAD DATA DARI DB (FIXED) ---
  Future<void> loadUserData() async {
    final session = _supabase.auth.currentSession;
    
    // Jika tidak ada sesi login, stop
    if (session == null) return;

    try {
      final userId = session.user.id;
      final userEmail = session.user.email ?? "";

      // Ambil data dari tabel 'profiles' berdasarkan ID user
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle(); // Pakai maybeSingle biar gak error kalau data belum ada

      if (data != null) {
        // Jika data ada di database, masukkan ke Model
        _user = UserModel(
          fullName: data['full_name'] ?? "",
          dob: data['dob'] ?? "",
          email: userEmail, // Email tetap dari Auth
          phone: data['phone'] ?? "",
          studentId: data['student_id'] ?? "",
          imageBytes: null, // Image via URL nanti (jika pakai storage)
        );
      } else {
        // Jika data belum ada (User baru), buat data kosong + email
        _user = UserModel(email: userEmail);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  // --- 2. UPDATE KE DB (FIXED) ---
  Future<void> updateProfile({
    required String name,
    required String dob,
    required String email,
    required String phone,
    required String studentId,
    Uint8List? image,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // A. Update State Lokal (Agar UI langsung berubah)
      _user = UserModel(
        fullName: name,
        dob: dob,
        email: email,
        phone: phone,
        studentId: studentId,
        imageBytes: image ?? _user.imageBytes,
      );
      notifyListeners();

      // B. Update ke Database Supabase (Agar Data Tersimpan Permanen)
      // Pastikan nama kolom di sini SAMA PERSIS dengan di Supabase kamu
      await _supabase.from('profiles').upsert({
        'id': user.id, // Primary Key
        'full_name': name,
        'dob': dob,
        'phone': phone,
        'student_id': studentId,
        'email': email,
        'updated_at': DateTime.now().toIso8601String(),
      });

      debugPrint("Profile success updated to DB!");

    } catch (e) {
      debugPrint("Error updating profile: $e");
    }
  }

  // --- 3. LOGOUT (FIXED) ---
  Future<void> logout(BuildContext context) async {
    try {
      // Sign out dari Supabase
      await _supabase.auth.signOut();

      // Reset Data User di Memory
      _user = UserModel(); 
      notifyListeners();

      // Navigasi ke Halaman Login
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()), 
          (route) => false, 
        );
      }
    } catch (e) {
      debugPrint("Error logging out: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  // --- 4. PICK IMAGE ---
  Future<Uint8List?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      return await pickedFile?.readAsBytes();
    } catch (e) {
      debugPrint("Error picking image: $e");
      return null;
    }
  }
}