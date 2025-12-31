part of 'pages.dart';


class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final JournalViewModel _viewModel = JournalViewModel();

  // Removed _stressLevel variable
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final Color _themeColor = Colors.deepOrange;
  final Color? _backgroundColor = Colors.deepOrange[50];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Call submit without stressLevel
    final success = await _viewModel.submitJournal(
      title: _titleController.text,
      content: _contentController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Journal Saved!")),
        );
        _titleController.clear();
        _contentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${_viewModel.errorMessage}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColor,
          appBar: AppBar(
            title: const Text("Add Journal"),
            backgroundColor: _themeColor,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Journal Title Input
                  _buildLabel("Journal Title"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: _inputDecoration(hint: "Enter title..."),
                  ),

                  const SizedBox(height: 24),

                  // "What you feel?" Input
                  _buildLabel("What you feel?"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 8, // Made it slightly larger since we removed the slider
                    decoration: _inputDecoration(hint: "Write your thoughts..."),
                  ),

                  const SizedBox(height: 40),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _viewModel.isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _themeColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _themeColor, width: 2.0),
      ),
    );
  }
}