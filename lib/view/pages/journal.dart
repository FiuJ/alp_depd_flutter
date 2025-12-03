part of 'pages.dart';

class journal extends StatefulWidget {
  const journal({super.key});

  @override
  State<journal> createState() => _journalState();
}

class _journalState extends State<journal> {
  // State variables
  double _stressLevel = 20;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Theme colors based on your reference "Work Mode" (Orange)
  final Color _themeColor = Colors.deepOrange;
  final Color? _backgroundColor = Colors.deepOrange[50];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("Add Journal"),
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      // We use a clean body to match the image's "Add Journal" header style
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
                decoration: _inputDecoration(hint: ""),
              ),

              const SizedBox(height: 24),

              // "What you feel?" Input
              _buildLabel("What you feel?"),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                maxLines: 6, // Makes the box taller
                decoration: _inputDecoration(hint: ""),
              ),

              const SizedBox(height: 24),

              // Stress Level Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Icon Container
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _themeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.coffee, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Stress Level",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          "${_stressLevel.toInt()}%",
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8,
                        activeTrackColor: _themeColor,
                        inactiveTrackColor: Colors.grey[200],
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12, elevation: 2),
                        overlayColor: _themeColor.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _stressLevel,
                        min: 0,
                        max: 100,
                        // Add a border to the thumb using logic inside thumbShape if needed, 
                        // but standard material slider is close enough.
                        onChanged: (value) {
                          setState(() {
                            _stressLevel = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Handle submit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _themeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Labels
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

  // Helper for Input Decoration to match the outlined orange style
  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white, // White background inside the text field
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _themeColor, width: 1.0), // Orange border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _themeColor, width: 2.0), // Thicker orange when focused
      ),
    );
  }
}