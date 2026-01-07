part of 'pages.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendRepository _repository = FriendRepository();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // --- Bottom Layer: The Content List ---
            FutureBuilder<List<ProfileModel>>(
              future: _repository.getFriends(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Friends found."));
                }

                final filteredFriends = snapshot.data!.where((friend) {
                  return friend.username.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredFriends.isEmpty && _searchQuery.isNotEmpty) {
                  // Added padding here so it doesn't get stuck under the search bar
                  return Container(
                    padding: const EdgeInsets.only(top: 85),
                    alignment: Alignment.center,
                    child: const Text("No matching friends found."),
                  );
                }

                return ListView.builder(
                  // Padding added to top to prevent list hiding behind floating bar
                  padding: const EdgeInsets.only(
                    top: 85,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  itemCount: filteredFriends.length,
                  itemBuilder: (context, index) {
                    final item = filteredFriends[index];
                    // This is the Card style we are matching
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          item.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Created At: ${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}",
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OtherUserProfilePage(friendData: item),
                            ),
                          ).then((_) => setState(() {}));
                        },
                      ),
                    );
                  },
                );
              },
            ),

            // --- Top Layer: The Floating Search Bar ---
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              // CHANGED: Changed Container to Card to match list items exactly
              child: Card(
                color: Colors.white,
                // clipBehavior ensures the child TextField respects the Card's rounded corners
                clipBehavior: Clip.antiAlias,
                // We use default elevation to match the list cards underneath
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search friends...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none, // Removes the underline
                    // Added horizontal padding so text doesn't touch card edge
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 8,
                    ),
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
