part of 'pages.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // 1. Logic to Logout
  Future<void> _handleLogout() async {
    // Sign out from Supabase
    await supabase.auth.signOut();

    if (mounted) {
      // Navigate to Login Page and remove all previous history (so you can't go back)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current user email to show (optional)
    final userEmail = supabase.auth.currentUser?.email ?? "User";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple Avatar Placeholder
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 16),

            Text("Logged in as:", style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 8),

            Text(
              userEmail,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 50),

            // --- EMERGENCY LOGOUT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50], // Light red background
                  foregroundColor: Colors.red, // Red text/icon
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Log Out",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
