// HAPUS part of 'pages.dart'; 
// File ini sekarang mandiri

import 'package:flutter/material.dart';

// PENTING: Import Repository dan Model ASLI yang dipakai repository
import '../../repository/friendRepository.dart'; 
// Ganti import ini ke model yang dipakai repository kamu (userModel.dart)
// BUKAN userProfile_model.dart
import '../../model/model.dart'; // Asumsi userModel.dart ada di sini atau import langsung userModel.dart

// Import untuk Navigasi ke Profile Teman (Menggunakan Alias biar tidak bentrok)
import 'other_user_profile_page.dart';
import '../../model/userProfile_model.dart' as ProfileModel; 

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final FriendRepository _repository = FriendRepository();

  // Pastikan tipe data Future sesuai dengan yang dikembalikan Repository
  // Jika repository mengembalikan List<UserModel> (versi lama), biarkan begini
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _repository.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _repository.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          final users = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = users[index];

              return Card(
                elevation: 0,
                color: Colors.grey[50],
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  
                  // Username & Tanggal
                  title: Text(
                    item.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Joined: ${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),

                  // Tombol Add Friend
                  trailing: item.alreadyFriend
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : IconButton(
                          icon: const Icon(Icons.person_add, color: Colors.blue),
                          onPressed: () async {
                            // Panggil fungsi Add Friend dari Repository
                            await _repository.addFriendRequest(item.id); // Pastikan item.id itu string UUID
                            
                            // Refresh tampilan setelah add
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Friend request sent!")),
                              );
                              _refreshUsers();
                            }
                          },
                        ),
                  
                  // Navigasi ke Profil Teman
                  onTap: () {
                    // Konversi UserModel (Lama) -> UserModel (Baru/Profile)
                    final profileUser = ProfileModel.UserModel(
                      fullName: item.username,
                      studentId: item.id.toString(), // ID sangat penting
                      email: "Hidden",
                      dob: "-",
                      phone: "-",
                      imageBytes: null,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfilePage(
                          friendData: profileUser,
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