part of 'pages.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final FriendRepository _repository = FriendRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<UserModel>> _usersFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _usersFuture = _repository.getUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = _repository.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // --- Bottom Layer: User List ---
            FutureBuilder<List<UserModel>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                // Filtering logic
                final filteredUsers = snapshot.data!.where((user) {
                  return user.username.toLowerCase().contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  // Matches the FriendsPage padding to clear the search bar
                  padding: const EdgeInsets.only(
                    top: 85,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final item = filteredUsers[index];

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

            // --- Top Layer: Floating Search Bar ---
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Card(
                color: Colors.white,
                elevation: 1, // Matches default card elevation
                clipBehavior: Clip.antiAlias,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search users...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
