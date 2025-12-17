part of 'pages.dart';

class AssignmentListPage extends StatefulWidget {
  // REMOVED: currentlySelected and onToggle parameters
  const AssignmentListPage({super.key});

  @override
  State<AssignmentListPage> createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage> {
  final AssignmentRepository _repository = AssignmentRepository();

  @override
  Widget build(BuildContext context) {
    // Access the central TimerViewModel
    final timerVM = Provider.of<Timerviewmodel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Assignments'), elevation: 0),
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

              // Use the ViewModel to check selection
              final isSelected = timerVM.isSelected(item.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Progress: ${item.progress.toInt()}%"),
                  trailing: Icon(
                    isSelected ? Icons.check_circle : Icons.add_circle_outline,
                    color: isSelected ? Colors.green : Colors.orange,
                  ),
                  onTap: () {
                    // Update the selection in the global ViewModel
                    timerVM.toggleSelection(item);
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
