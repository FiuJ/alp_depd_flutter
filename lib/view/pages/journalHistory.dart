part of 'pages.dart';

class Journalhistory extends StatefulWidget {
  const Journalhistory({super.key});

  @override
  State<Journalhistory> createState() => _JournalhistoryState();
}

class _JournalhistoryState extends State<Journalhistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Journal History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: _mockJournals.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final journal = _mockJournals[index];
          return _buildJournalCard(journal);
        },
      ),
    );
  }

  Widget _buildJournalCard(Map<String, String> journal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon (Simulated A+ Paper Icon)
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 50,
                color: Colors.deepOrange,
              ),
              Positioned(
                top: 18,
                child: Text(
                  "A+",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Date
                Text(
                  journal["date"]!,
                  style: TextStyle(
                    color: const Color(0xFF4A3B32).withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                // Title
                Text(
                  journal["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3B32),
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  journal["description"]!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mock Data
  static final List<Map<String, String>> _mockJournals = [
    {
      "date": "12 November 2025",
      "title": "My day before exam.",
      "description": "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et."
    },
    {
      "date": "10 November 2025",
      "title": "Feeling productive!",
      "description": "Today I managed to finish all my tasks before noon. The pomodoro technique really helped me focus."
    },
    {
      "date": "08 November 2025",
      "title": "A bit stressed...",
      "description": "Had a lot of meetings today. Need to remember to take deep breaths and stick to the break schedule."
    },
    {
      "date": "05 November 2025",
      "title": "Project Kickoff",
      "description": "Started the new design project. The team seems excited, but the timeline is tight."
    },
    {
      "date": "01 November 2025",
      "title": "Monthly Reflection",
      "description": "Looking back at October, I think I improved my sleep schedule significantly."
    },
  ];


}