part of 'pages.dart';

class Assignmentdetailpage extends StatefulWidget {
  final Assignment assignment;
  const Assignmentdetailpage({super.key, required this.assignment});

  @override
  State<Assignmentdetailpage> createState() => _AssignmentdetailpageState();
}

class _AssignmentdetailpageState extends State<Assignmentdetailpage> {
  String _formatDate(DateTime date) {
    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDate(widget.assignment.dueDate),
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              widget.assignment.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3B32),
                height: 1.3,
              ),
            ),

            const SizedBox(height: 24),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.withValues(alpha: 0.2),
            ),

            const SizedBox(height: 24),

            // Main Content
            Text(
              widget.assignment.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
