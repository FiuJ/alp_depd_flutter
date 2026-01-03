part of 'pages.dart';

class OtherUserProfilePage extends StatefulWidget {
  final ProfileModel friendData;

  const OtherUserProfilePage({super.key, required this.friendData});

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  late Future<List<OtherJournalModel>> _journalsFuture;
  late Future<List<OtherAssignmentModel>> _assignmentsFuture;

  @override
  void initState() {
    super.initState();
    _journalsFuture = _fetchFriendJournals();
    _assignmentsFuture = _fetchFriendAssignments();
  }

  Future<List<OtherJournalModel>> _fetchFriendJournals() async {
    try {
      final response = await supabase
          .from('journal')
          .select()
          .eq('user_id', widget.friendData.id)
          .limit(10);

      final data = response as List<dynamic>;
      return data.map((e) => OtherJournalModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching journals: $e");
      return [];
    }
  }

  Future<List<OtherAssignmentModel>> _fetchFriendAssignments() async {
    try {
      final response = await supabase
          .from('assignments')
          .select()
          .eq('user_id', widget.friendData.id);

      final data = response as List<dynamic>;
      return data.map((e) => OtherAssignmentModel.fromJson(e)).toList();
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
        title: Text(
          widget.friendData.username,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DefaultTabController(
        length: 2,
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
                    backgroundImage:
                        const AssetImage('assets/characters/character.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.friendData.username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  // Text(
                  //   "Student ID: ${widget.friendData.studentId}",
                  //   style: TextStyle(color: Colors.grey[600]),
                  // ),
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
                Tab(text: "Journals"),
                Tab(text: "Tasks"),
              ],
            ),

            // TAB VIEW CONTENT
            Expanded(
              child: TabBarView(
                children: [_buildJournalsTab(), _buildAssignmentsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value.isEmpty ? "-" : value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildJournalsTab() {
    return FutureBuilder<List<OtherJournalModel>>(
      future: _journalsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text("No journals shared."));

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
                title: Text(
                  journal.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  journal.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAssignmentsTab() {
    return FutureBuilder<List<OtherAssignmentModel>>(
      future: _assignmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text("No assignments yet."));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final task = snapshot.data![index];
            return Card(
              color: Colors.white,
              child: ListTile(
                title: Text(task.title),
                subtitle: Text("Progress: ${task.progress}%"),
              ),
            );
          },
        );
      },
    );
  }
}
