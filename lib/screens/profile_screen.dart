import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'updateProfile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data State Kosong (Agar user isi sendiri)
  String _fullName = "";
  String _dob = "";
  String _email = "";
  String _phone = "";
  String _studentId = "";
  
  // Variable untuk menyimpan gambar profil (Memory Bytes)
  Uint8List? _profileImageBytes;

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 180;
    const double avatarSize = 120;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // --- LAYER 1: CONTENT DATA ---
                Padding(
                  padding: const EdgeInsets.only(top: headerHeight + (avatarSize / 2) + 20),
                  child: Column(
                    children: [
                      // Nama Besar (Tampilkan Placeholder jika kosong)
                      Text(
                        _fullName.isEmpty ? "Your Name" : _fullName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Student",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 32),

                      // List Data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _buildProfileItem(icon: Icons.cake, label: "Date of Birth", value: _dob),
                            _buildProfileItem(icon: Icons.email, label: "Email Address", value: _email),
                            _buildProfileItem(icon: Icons.phone, label: "Phone Number", value: _phone),
                            _buildProfileItem(icon: Icons.badge, label: "Student ID (NIM)", value: _studentId, isLast: true),

                            const SizedBox(height: 40),

                            // --- TOMBOL MENUJU EDIT PROFILE ---
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // 1. Pindah ke Halaman Edit sambil BAWA DATA SAAT INI
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProfileScreen(
                                        initialName: _fullName,
                                        initialDob: _dob,
                                        initialEmail: _email,
                                        initialPhone: _phone,
                                        initialStudentId: _studentId,
                                        initialImageBytes: _profileImageBytes, // Kirim gambar saat ini
                                      ),
                                    ),
                                  );

                                  // 2. Jika kembali membawa data (Save ditekan), update tampilan
                                  if (result != null && result is Map<String, dynamic>) {
                                    setState(() {
                                      _fullName = result['name'];
                                      _dob = result['dob'];
                                      _email = result['email'];
                                      _phone = result['phone'];
                                      _studentId = result['studentId'];
                                      // Update Gambar jika ada
                                      if (result['imageBytes'] != null) {
                                        _profileImageBytes = result['imageBytes'];
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 2,
                                ),
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --- LAYER 2: ORANGE HEADER ---
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: _CurvedClipper(),
                    child: Container(
                      height: headerHeight,
                      color: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          'My Profile',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),

                // --- LAYER 3: AVATAR ---
                Positioned(
                  top: headerHeight - (avatarSize / 2),
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(color: AppColors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipOval(
                        // LOGIKA TAMPILKAN GAMBAR (Memory > Asset Default)
                        child: _profileImageBytes != null
                            ? Image.memory(
                                _profileImageBytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/characters/character.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({required IconData icon, required String label, required String value, bool isLast = false}) {
    // Jika value kosong, tampilkan "-" agar layout tetap rapi
    final displayValue = value.isEmpty ? "-" : value;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(displayValue, style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                if (!isLast) Container(margin: const EdgeInsets.only(top: 12), height: 1, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.85);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}