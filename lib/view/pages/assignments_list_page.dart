part of 'pages.dart';

class AssignmentListPage extends StatefulWidget {
  const AssignmentListPage({super.key});

  @override
  State<AssignmentListPage> createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage> {
  final AssignmentRepository _repository = AssignmentRepository();

  @override
  Widget build(BuildContext context) {
    final timerVM = Provider.of<Timerviewmodel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Assignments'), elevation: 0),

      floatingActionButton: FloatingActionButton(
        heroTag: "add_assignment_btn",
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssignmentFormPage()),
          ).then((_) {
            setState(() {});
          });
        },
      ),

      body: FutureBuilder<List<Assignment>>(
        future: _repository.getAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No assignments found."));
          }

          final assignments = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final item = assignments[index];
              final isSelected = timerVM.isSelected(item.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Progress: ${item.progress.toInt()}%"),
                  trailing: IconButton(
                    icon: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.add_circle_outline,
                      color: isSelected ? Colors.green : Colors.orange,
                    ),
                    onPressed: () {
                      timerVM.toggleSelection(item);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Assignmentdetailpage(assignment: item),
                      ),
                    ).then((_) {
                      // Refresh the list when returning from the form
                      setState(() {});
                    });
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
