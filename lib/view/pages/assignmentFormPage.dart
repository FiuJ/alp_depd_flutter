part of 'pages.dart';

class AssignmentFormPage extends StatefulWidget {
  const AssignmentFormPage({super.key});

  @override
  State<AssignmentFormPage> createState() => _AssignmentFormPageState();
}

class _AssignmentFormPageState extends State<AssignmentFormPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the assignment provider
    final assignmentVM = Provider.of<AssignmentViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Assignment"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Due Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              ),
              subtitle: const Text("Tap to change date"),
              trailing: const Icon(Icons.calendar_today, color: Colors.orange),
              onTap: () => _selectDate(context),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(58),
                ),
                // --- MODIFIED ONPRESSED BLOCK ---
                onPressed: assignmentVM.isLoading
                    ? null
                    : () async {
                        // 1. Hide any existing snackbars
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        // 2. Call the save logic
                        await assignmentVM.saveAssignment(
                          title: _titleController.text.trim(),
                          description: _descController.text.trim(),
                          dueDate: _selectedDate,
                          onSuccess: () {
                            // 3. Show success message if everything went well
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Assignment saved successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        );

                        // 4. If an error occurred in the DB, display it
                        if (mounted && assignmentVM.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(assignmentVM.errorMessage!),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                child: assignmentVM.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Assignment",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
