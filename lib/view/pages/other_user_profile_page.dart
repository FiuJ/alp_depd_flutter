import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/colors.dart';

// PASTIKAN NAMA FILE MODEL SESUAI. 
// Jika file modelmu bernama userProfile_model.dart, pakai baris ini:
import '../../model/userProfile_model.dart'; 
// Jika file modelmu bernama user_model.dart, ganti jadi import '../../model/user_model.dart';

import '../../model/other_user_content_model.dart'; 

class OtherUserProfilePage extends StatefulWidget {
  final UserModel friendData; 

  const OtherUserProfilePage({super.key, required this.friendData});

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  late Future<List<JournalModel>> _journalsFuture;
  late Future<List<AssignmentModel>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _journalsFuture = _fetchFriendJournals();
    _assignmentsFuture = _fetchFriendAssignments();
  }

  Future<List<JournalModel>> _fetchFriendJournals() async {
    try {
      final response = await Supabase.instance.client
          .from('journals') 
          .select()
          .eq('user_id', widget.friendData.studentId) 
          .order('created_at', ascending: false)
          .limit(10); 

      final data = response as List<dynamic>;
      return data.map((e) => JournalModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching journals: $e");
      return [];
    }
  }

  Future<List<AssignmentModel>> _fetchFriendAssignments() async {
    try {
      final response = await Supabase.instance.client
          .from('assignments') 
          .select()
          .eq('user_id', widget.friendData.studentId)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((e) => AssignmentModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching assignments: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.friendData.fullName, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // HEADER PROFILE
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: widget.friendData.imageBytes != null 
                        ? MemoryImage(widget.friendData.imageBytes!) 
                        : const AssetImage('assets/characters/character.png') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.friendData.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Text(
                    "Student ID: ${widget.friendData.studentId}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // TAB BAR
            const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: "Info"),
                Tab(text: "Journals"),
                Tab(text: "Tasks"),
              ],
            ),

            // TAB VIEW CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  _buildInfoTab(),
                  _buildJournalsTab(),
                  _buildAssignmentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _infoTile(Icons.cake, "Date of Birth", widget.friendData.dob),
        _infoTile(Icons.email, "Email", widget.friendData.email),
        _infoTile(Icons.phone, "Phone", widget.friendData.phone),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value.isEmpty ? "-" : value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildJournalsTab() {
    return FutureBuilder<List<JournalModel>>(
      future: _journalsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No journals shared."));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final journal = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.orange),
                title: Text(journal.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(journal.content, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAssignmentsTab() {
    return FutureBuilder<List<AssignmentModel>>(
      future: _assignmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No assignments yet."));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final task = snapshot.data![index];
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
                title: Text(task.taskName),
                subtitle: Text(task.isCompleted ? "Completed" : "Pending"),
              ),
            );
          },
        );
      },
    );
  }
}