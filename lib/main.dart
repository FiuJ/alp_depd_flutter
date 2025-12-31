import 'package:alp_depd_flutter/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'viewmodel/timerViewmodel.dart';
import 'constants/colors.dart';

// --- IMPORT DASHBOARD, JOURNAL, USERS, MINIGAME ---
// Pastikan pages.dart TIDAK lagi meng-export profile lama
import 'view/pages/pages.dart'; 

// --- IMPORT KHUSUS PROFILE BARU ---
// Ini penting agar aplikasi memanggil ProfilePage yang baru (bukan yang lama)
import 'view/pages/profile_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  await Supabase.initialize(
    url: Const.supabaseUrl,
    anonKey: Const.supabaseAnonKey,
  );
  supabase = Supabase.instance.client;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Timerviewmodel())],
      child: const MyApp(),
    ),
  );
}

late final SupabaseClient supabase;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEPD - Daily Wellness',
      theme: ThemeData(
        // Gunakan AppColors.primary agar konsisten di seluruh aplikasi
        primaryColor: AppColors.primary, 
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // Logic: Cek sesi login. Jika ada sesi, masuk MainNav. Jika tidak, ke Login.
      home: Supabase.instance.client.auth.currentSession != null
          ? const MainNavigation()
          : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // DAFTAR HALAMAN
  // Pastikan urutannya sesuai dengan icon di BottomNavigationBar
  final List<Widget> _pages = const [
    Timersettingspage(), // Index 0: Timer
    Summary(),           // Index 1: Journal
    UsersPage(),         // Index 2: Community (Users & Friends)
    Minigame(),          // Index 3: Minigame
    ProfilePage(),       // Index 4: Profile (VERSI BARU)
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar state halaman (seperti scroll position) tidak hilang saat pindah tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // MODIFIKASI: Gunakan AppColors.primary agar warnanya oranye sama dengan header Profile
        selectedItemColor: AppColors.primary, 
        unselectedItemColor: Colors.grey,
        
        type: BottomNavigationBarType.fixed, // Wajib agar label muncul semua jika item > 3
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer_outlined), activeIcon: Icon(Icons.timer), label: "Timer"),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), activeIcon: Icon(Icons.book), label: "Journal"),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), activeIcon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.games_outlined), activeIcon: Icon(Icons.games), label: "Game"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}