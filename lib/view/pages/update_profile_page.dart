import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/colors.dart';
import '../../viewmodel/profile_viewmodel.dart';
// Pastikan import model ini sesuai dengan yang kamu pakai (userProfile_model.dart atau user_model.dart)
import '../../model/userProfile_model.dart'; 

class UpdateProfilePage extends StatefulWidget {
  // Kita ubah agar menerima 1 object User utuh
  final UserModel user;

  const UpdateProfilePage({super.key, required this.user});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _studentIdController;
  
  // Image Variable
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    // Isi data awal dari widget.user
    _nameController = TextEditingController(text: widget.user.fullName);
    _dobController = TextEditingController(text: widget.user.dob);
    _phoneController = TextEditingController(text: widget.user.phone);
    _studentIdController = TextEditingController(text: widget.user.studentId);
    _imageBytes = widget.user.imageBytes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  // Fungsi Pilih Gambar
  Future<void> _pickImage() async {
    final Uint8List? pickedImage = await ProfileViewModel.instance.pickImage();
    if (pickedImage != null) {
      setState(() {
        _imageBytes = pickedImage;
      });
    }
  }

  // Fungsi Simpan Data
  void _saveProfile() {
    // Panggil fungsi update di ViewModel
    ProfileViewModel.instance.updateProfile(
      name: _nameController.text,
      dob: _dobController.text,
      email: widget.user.email, // Email tidak diedit, ambil dari data lama
      phone: _phoneController.text,
      studentId: _studentIdController.text,
      image: _imageBytes,
    );
    
    // Kembali ke halaman sebelumnya dengan status 'true' (berhasil update)
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- EDIT IMAGE ---
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageBytes != null
                        ? MemoryImage(_imageBytes!)
                        : const AssetImage('assets/characters/character.png') as ImageProvider,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- FORM FIELDS ---
            _buildTextField("Full Name", _nameController, Icons.person),
            const SizedBox(height: 16),
            
            _buildTextField("Student ID", _studentIdController, Icons.badge),
            const SizedBox(height: 16),

            // Read Only Email (Tidak bisa diedit)
            _buildReadOnlyField("Email", widget.user.email, Icons.email),
            const SizedBox(height: 16),

            _buildTextField("Date of Birth", _dobController, Icons.calendar_today, isDate: true),
            const SizedBox(height: 16),

            _buildTextField("Phone Number", _phoneController, Icons.phone, isNumber: true),
            const SizedBox(height: 40),

            // --- SAVE BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool isDate = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      readOnly: isDate, // Jika tanggal, tidak bisa ketik manual
      onTap: isDate ? () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          // Format sederhana YYYY-MM-DD
          String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}";
          setState(() {
            controller.text = formattedDate;
          });
        }
      } : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}