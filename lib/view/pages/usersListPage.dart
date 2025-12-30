part of 'pages.dart';

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
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          final assignments = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final item = assignments[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    item.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Created At: ${item.createdAt.day} - ${item.createdAt.month} - ${item.createdAt.year}",
                  ),
                  trailing: IconButton(
                    disabledColor: Colors.grey,
                    onPressed: item.alreadyFriend
                        ? null
                        : () async {
                            await _repository.addFriendRequest(item.id);
                            _refreshUsers();
                          },
                    icon: const Icon(Icons.person_add),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
