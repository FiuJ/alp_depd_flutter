
part of 'pages.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {

  final JournalViewModel _viewModel = JournalViewModel();

  int stressLevel = 24;      // Percentage
  int tasksDone = 12;        // Count
  int focusTime = 103;       // In Minutes
  int restTime = 35;         // In Minutes

  @override
  void initState() {
    super.initState();
    // 2. Fetch data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchJournals();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child){
        return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. "How are you today" Banner
              Container(
                height: 280, 
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E3), // Light peach color
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const Text(
                      "How are you today?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3B32), 
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SvgPicture.asset('assets/images/YuccaHome.svg', height: 300),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 2. "Your Condition Result" Title
              const Text(
                "Your Condition Result",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A3B32),
                ),
              ),

              const SizedBox(height: 15),

              // 3. Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.psychology_outlined, 
                      value: "$stressLevel%",
                      label: "Stress Level",
                      iconColor: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle_outline,
                      value: "$tasksDone",
                      label: "Task Done this Week",
                      iconColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.gps_fixed, 
                      value: "${focusTime}min",
                      label: "Focus Time",
                      iconColor: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.bedtime_outlined, 
                      value: "${restTime}min",
                      label: "Rest Time",
                      iconColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Journal(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Start Journalling",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 30),

              // 4. "Your Journal" Section (Updated Design)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Journal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A3B32),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Journalhistory(),
                        ),
                      );
                    },
                    child: const Text("See All", style: TextStyle(color: Colors.blue)),
                  )
                ],
              ),
              
              // Journal Card
              


              // 5. Start Session Button
              
              const SizedBox(height: 20),

              // _buildRecentJournalsList(),
                  
                  const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
      }
    );
  }

  Widget _buildRecentJournalsList() {
    if (_viewModel.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.deepOrange));
    }

    if (_viewModel.journals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Text(
          "No journals yet. Start writing today!",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Take only the first 2 items
    final recentJournals = _viewModel.journals.take(2).toList();

    return Column(
      children: recentJournals.map((journal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0), // Spacing between cards
          child: _buildJournalCard(journal),
        );
      }).toList(),
    );
  }

  // The Card Style (Copied exactly from your History page)
  Widget _buildJournalCard(JournalModel journal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetail(journal: journal),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                const Positioned(
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
                    _formatDate(journal.date),
                    style: TextStyle(
                      color: const Color(0xFF4A3B32).withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    journal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3B32),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    journal.content,
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
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EB), // Very light orange/beige
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Icon(icon, color: iconColor, size: 40),
          
          // Text Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3B32),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}