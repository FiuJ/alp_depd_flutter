import 'package:flutter/material.dart';
import '../../repository/assignmentRepository.dart';

class AssignmentFormPage extends StatefulWidget {
  const AssignmentFormPage({super.key});

  @override
  State<AssignmentFormPage> createState() => _AssignmentFormPageState();
}

class _AssignmentFormPageState extends State<AssignmentFormPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final DateTime _dueDate = DateTime.now();
  final _repo = AssignmentRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Assignment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _repo.saveAssignment(
                  _titleController.text,
                  _descController.text,
                  _dueDate,
                );
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
