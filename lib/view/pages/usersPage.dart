part of 'pages.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

List<String> titles = <String>['Friends', 'Users'];

class _UsersPageState extends State<UsersPage> {
  final FriendRepository _repository = FriendRepository();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          // This check specifies which nested Scrollable's scroll notification
          // should be listened to.
          //
          // When `ThemeData.useMaterial3` is true and scroll view has
          // scrolled underneath the app bar, this updates the app bar
          // background color and elevation.
          //
          // This sets `notification.depth == 1` to listen to the scroll
          // notification from the nested `ListView.builder`.
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          // The elevation value of the app bar when scroll view has
          // scrolled underneath the app bar.
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.face_retouching_natural_outlined),
                text: titles[0],
              ),
              Tab(icon: const Icon(Icons.public), text: titles[1]),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          heroTag: "friend_request_btn",
          backgroundColor: Colors.orange,
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

        body: TabBarView(children: <Widget>[FriendsPage(), UsersListPage()]),
      ),
    );
  }
}
