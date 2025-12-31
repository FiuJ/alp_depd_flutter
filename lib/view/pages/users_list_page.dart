import 'package:flutter/material.dart';
import '../../repository/friendRepository.dart'; 
import '../../model/model.dart'; // Import userModel.dart (Auth version)
import 'other_user_profile_page.dart'; // Import halaman profil teman
import '../../model/userProfile_model.dart' as ProfileModel; // Import userProfile_model (Profile version)

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final FriendRepository _repository = FriendRepository();
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _usersFuture = _repository.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background bersih
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Error
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // 3. Kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found in community."));
          }

          final users = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = users[index];

              // Handle "No Name" user (User yang belum setup profile)
              final displayName = item.username.isEmpty ? "No Name" : item.username;
              final displaySubtitle = item.username.isEmpty 
                  ? "User hasn't set up profile" 
                  : "Joined: ${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}";

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  
                  // AVATAR
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    child: Text(
                      displayName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.orange, 
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                  
                  // NAMA USER
                  title: Text(
                    displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  
                  // INFO TANGGAL
                  subtitle: Text(
                    displaySubtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),

                  // LOGIC TOMBOL ADD FRIEND (Kanan)
                  trailing: item.alreadyFriend
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Friend",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.person_add_alt_1, color: Colors.blue),
                          tooltip: "Add Friend",
                          onPressed: () async {
                            // Panggil fungsi add friend
                            await _repository.addFriendRequest(item.id);
                            
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Request sent to $displayName")),
                              );
                              // Refresh list agar status berubah
                              _loadUsers();
                            }
                          },
                        ),
                  
                  // NAVIGASI KE PROFIL (Klik Card)
                  onTap: () {
                    // Konversi data agar bisa dibaca halaman profile
                    final profileData = ProfileModel.UserModel(
                      fullName: displayName,
                      studentId: item.id.toString(), // ID Supabase (String UUID)
                      email: "Hidden",
                      dob: "-",
                      phone: "-",
                      imageBytes: null,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfilePage(
                          friendData: profileData,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}