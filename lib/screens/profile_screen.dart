import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 1. Variable untuk menyimpan nama yang ditampilkan (Default: Yukaaa)
  String _displayName = "Yukaaa";

  // Form controllers
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  
  // 2. Mengganti controller placeholder menjadi field yang relevan
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _studentIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set nilai awal input nama sesuai dengan nama yang ditampilkan sekarang
    _nameController.text = _displayName;
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

  @override
  Widget build(BuildContext context) {
    // Ukuran tinggi header orange
    const double headerHeight = 180;
    // Ukuran avatar
    const double avatarSize = 120;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Stack untuk menumpuk Header Orange, Avatar, dan Konten Putih
          Stack(
            clipBehavior: Clip.none, // Izinkan avatar keluar dari batas widget
            alignment: Alignment.center,
            children: [
              // Layer 1: Container untuk memberi ruang konten di bawah header
              // Ini agar form tidak tertutup header
              Padding(
                padding: const EdgeInsets.only(top: headerHeight + (avatarSize / 2) + 20),
                child: Column(
                  children: [
                    // Text Nama Display (Dinamis)
                    Text(
                      _displayName, // Menggunakan variable state
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 32),
                    // Personal Information Form
                    _buildPersonalInfoForm(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Layer 2: Orange Curved Header (Paling Atas)
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
                        'Profile',
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

              // Layer 3: Avatar (Tepat di tengah perbatasan curve)
              // Rumus: Top = Tinggi Header - (Setengah Tinggi Avatar)
              Positioned(
                top: headerHeight - (avatarSize / 2), 
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.white, width: 4), // Border putih agar rapi
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
                      child: Image.asset(
                        'assets/characters/character.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          
          // Field 1: Name
          _buildFormField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
          ),
          
          // Field 2: Date of Birth
          _buildFormField(
            controller: _dobController,
            label: 'Date of Birth',
            hint: 'Select your date of birth',
            isDateField: true,
          ),
          
          // Field 3: Email (Mengganti Phone 1)
          _buildFormField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter your email address',
            inputType: TextInputType.emailAddress,
          ),
          
          // Field 4: Phone Number (Mengganti Phone 2)
          _buildFormField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            inputType: TextInputType.phone,
          ),
          
          // Field 5: Student ID / Bio (Mengganti Phone 3)
          _buildFormField(
            controller: _studentIdController,
            label: 'Student ID (NIM)',
            hint: 'Enter your student ID number',
            inputType: TextInputType.number,
          ),

          // Save Button
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // 3. Logic Update Nama saat Save ditekan
                setState(() {
                  if (_nameController.text.isNotEmpty) {
                    _displayName = _nameController.text;
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Save Changes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
              ),
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
    bool isDateField = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        TextField(
          controller: controller,
          readOnly: isDateField,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.mediumGray.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: isDateField
                ? GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        controller.text =
                            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                      }
                    },
                    child: const Icon(Icons.calendar_month_rounded,
                        color: AppColors.primary),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Custom clipper for curved header (Sudah oke, tidak perlu diubah)
class _CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85); // Titik awal lengkungan kiri
    path.quadraticBezierTo(
      size.width / 2, // Titik kontrol tengah (bawah)
      size.height,    // Tinggi maksimal lengkungan
      size.width,     // Titik akhir kanan
      size.height * 0.85, // Titik akhir lengkungan kanan
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}