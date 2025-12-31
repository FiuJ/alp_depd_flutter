import 'package:flutter/material.dart';

// 1. Import Repository & Model asli
import '../../repository/friendRepository.dart'; 
import '../../model/model.dart'; // Tempat FriendModel berada

// 2. Import Model Profile dengan ALIAS (PENTING AGAR TIDAK ERROR)
import '../../model/userProfile_model.dart' as ProfileModel; 

// 3. Import Halaman Tujuan
import 'other_user_profile_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendRepository _repository = FriendRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<FriendModel>>(
        future: _repository.getFriends(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Empty / Error State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No friends found."));
          }

          final friends = snapshot.data!;
          
          // 3. List Data
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = friends[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: const Icon(Icons.face, color: Colors.orange),
                ),
                title: Text(
                  item.username, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  "Friend since: ${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                
                // --- NAVIGASI (SUDAH DIPERBAIKI) ---
                onTap: () {
                  // Konversi FriendModel -> ProfileModel.UserModel
                  final friendAsUser = ProfileModel.UserModel(
                    // Username dari FriendModel
                    fullName: item.username, 
                    
                    // ID dari FriendModel (int) diubah ke String
                    // Sesuai dengan repository kamu, id teman ada di 'item.id'
                    studentId: item.id.toString(), 
                    
                    // Data Dummy untuk field yang tidak ada di FriendModel
                    email: "No Email", 
                    dob: "-", 
                    phone: "-",
                    imageBytes: null,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherUserProfilePage(
                        friendData: friendAsUser,
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}