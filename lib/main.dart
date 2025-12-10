import 'package:flutter/material.dart';
import 'constants/theme.dart'; // Pastikan path ini sesuai
import 'constants/colors.dart'; // Import colors untuk styling navbar

// Import screen yang benar
import 'screens/dashboard_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/profile_screen.dart'; // Ubah dari updateProfile menjadi profile_screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEPD - Daily Wellness',
      // Pastikan kamu punya file theme.dart, jika belum hapus baris theme ini
      // atau gunakan ThemeData(primaryColor: AppColors.primary)
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial', // Sesuaikan dengan font projectmu
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const MainAppScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // List Screen Utama
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TimerScreen(),
    const ProfileScreen(), // PERBAIKAN: Mengarah ke ProfileScreen (View), bukan Update
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        // Menambahkan sedikit shadow agar navbar terlihat lebih pop-up
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavBarTapped,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary, // Warna Orange saat aktif
          unselectedItemColor: Colors.grey,     // Warna Abu saat tidak aktif
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,  // Agar item tidak bergeser
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              activeIcon: Icon(Icons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}