import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialDob;
  final String initialEmail;
  final String initialPhone;
  final String initialStudentId;
  final Uint8List? initialImageBytes; // Tambahan untuk terima gambar awal

  const UpdateProfileScreen({
    super.key,
    required this.initialName,
    required this.initialDob,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialStudentId,
    this.initialImageBytes,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _studentIdController;
  Uint8List? _selectedImageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _dobController = TextEditingController(text: widget.initialDob);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _studentIdController = TextEditingController(text: widget.initialStudentId);
    _selectedImageBytes = widget.initialImageBytes;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = imageBytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

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
                // Layer 1: Form Content
                Padding(
                  padding: const EdgeInsets.only(top: headerHeight + (avatarSize / 2) + 20),
                  child: Column(
                    children: [
                      Text(
                        _nameController.text.isEmpty ? "Your Name" : _nameController.text,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 32),
                      _buildFormContent(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),

                // Layer 2: Orange Header
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
                          'Update Profile',
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

                // Layer 3: Avatar
                Positioned(
                  top: headerHeight - (avatarSize / 2),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
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
                              child: _selectedImageBytes != null
                                  ? Image.memory(
                                      _selectedImageBytes!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/characters/character.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.person, size: 60, color: AppColors.primary),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
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

  Widget _buildFormContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit Details', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          
          _buildFormField(
            controller: _nameController, 
            label: 'Full Name', 
            hint: 'e.g. John Doe', 
            icon: Icons.person_outline
          ),
          
          _buildFormField(
            controller: _dobController, 
            label: 'Date of Birth', 
            hint: 'Tap to select date', 
            isDateField: true, 
            icon: Icons.cake_outlined
          ),
          
          _buildFormField(
            controller: _emailController, 
            label: 'Email Address', 
            hint: 'e.g. john.doe@email.com', 
            inputType: TextInputType.emailAddress, 
            icon: Icons.email_outlined
          ),
          
          _buildFormField(
            controller: _phoneController, 
            label: 'Phone Number', 
            hint: 'e.g. 08123456789', 
            inputType: TextInputType.phone, 
            icon: Icons.phone_outlined
          ),
          
          _buildFormField(
            controller: _studentIdController, 
            label: 'Student ID (NIM)', 
            hint: 'e.g. 07060123xxx', 
            inputType: TextInputType.number, 
            icon: Icons.badge_outlined
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'dob': _dobController.text,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                  'studentId': _studentIdController.text,
                  'imageBytes': _selectedImageBytes,
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isDateField = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.darkGray, fontWeight: FontWeight.w600)),
        ),
        TextField(
          controller: controller,
          readOnly: isDateField,
          keyboardType: inputType,
          onChanged: (value) => setState(() {}), // Update nama di header realtime
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7)),
            hintStyle: TextStyle(color: AppColors.mediumGray.withOpacity(0.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderGray)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderGray)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: isDateField ? const Icon(Icons.calendar_month_rounded, color: AppColors.primary) : null,
          ),
          onTap: isDateField
              ? () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: AppColors.primary)), child: child!),
                  );
                  if (pickedDate != null) {
                    controller.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  }
                }
              : null,
        ),
        const SizedBox(height: 16),
      ],
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