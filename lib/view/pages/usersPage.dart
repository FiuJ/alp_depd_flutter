part of 'pages.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

List<String> titles = <String>['Friends', 'Users'];

class _UsersPageState extends State<UsersPage> {
  // Repository dihapus dari sini karena logicnya sudah ada di dalam FriendsPage & UsersListPage

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length, // Pastikan length = 2 sesuai jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          // Pengaturan scroll style bawaan kamu
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          
          // Tab Header
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.face_retouching_natural_outlined),
                text: titles[0], // Friends
              ),
              Tab(
                icon: const Icon(Icons.public), 
                text: titles[1] // Users
              ),
            ],
          ),
        ),

        // Floating Action Button (Friend Request)
        floatingActionButton: FloatingActionButton(
          heroTag: "friend_request_btn",
          backgroundColor: Colors.orange, // Bisa ganti AppColors.primary agar konsisten
          child: const Icon(Icons.mail_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FriendRequestPage(),
              ),
            ).then((_) {
              setState(() {});
            });
          },
        ),

        // BODY: Memanggil 2 Halaman yang sudah kita siapkan
        body: const TabBarView(
          children: <Widget>[
            FriendsPage(),    // Halaman list teman (yang sudah dimodifikasi navigasinya)
            UsersListPage(),  // Halaman list semua user (yang baru dibuat)
          ],
        ),
      ),
    );
  }
}