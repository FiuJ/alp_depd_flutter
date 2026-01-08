part of 'pages.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final JournalViewModel _journalViewModel = JournalViewModel();
  final StatsRepository _statsRepo = StatsRepository();
  final AssignmentRepository _assignmentRepo = AssignmentRepository();

  String _getYuccaAsset(double score) {
    // if (score <= 33.3) {
    //   return 'assets/images/YuccaHome.svg';
    // } else if (score <= 66.6) {
    //   return 'assets/images/YuccaNeutral.svg';
    // } else {
    //   return 'assets/images/YuccaSad.svg';
    // }
    if (score <= 25) return 'assets/images/YuccaHappy.png';
    if (score <= 50) return 'assets/images/YuccaNeutral.png';
    return 'assets/images/YuccaSad.png';
  }

  late Future<Map<String, dynamic>> _statsFuture;

  Future<Map<String, dynamic>> _loadStats() async {
    try {
      final results = await Future.wait([
        _assignmentRepo.getWeeklyCompletedTasksCount(),
        _statsRepo.getWeeklyStats(),
      ]);
      return {'tasks': results[0], 'timer': results[1]};
    } catch (e) {
      print("Fetch Error: $e");
      rethrow; // Let FutureBuilder handle the error
    }
  }

  @override
  void initState() {
    super.initState();

    // 1. Initialize IMMEDIATELY so build() can access it right away
    _statsFuture = _loadStats();

    // 2. These remain in the callback as they are just firing background fetches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _journalViewModel.fetchJournals();
      if (context.mounted) {
        context.read<StressViewModel>().fetchHistory();
      }
    });
  }

  @override
  void dispose() {
    _journalViewModel.dispose();
    super.dispose();
  }

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
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _journalViewModel,
      builder: (context, child) {
        return Consumer<StressViewModel>(
          builder: (context, stressVM, child) {
            final latestStress = stressVM.stressHistory.isNotEmpty
                ? stressVM.stressHistory.last.totalPercentage
                : 0.0;

            final yuccaAsset = _getYuccaAsset(latestStress);

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text(""),
                backgroundColor: Colors.white,
                elevation: 0,
                foregroundColor: Colors.black,
                automaticallyImplyLeading: false,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 280,
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0E3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            
                            //Bugfixing
                            const Text(
                              "Your Condition",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A3B32),
                              ),
                            ),

                            const SizedBox(height: 15),

                            const SizedBox(height: 10),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  yuccaAsset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Condition Result",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3B32),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // --- DYNAMIC STATS GRID START ---
                      FutureBuilder<Map<String, dynamic>>(
                        future: _statsFuture,
                        // Inside your Summary.dart FutureBuilder builder:
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Error loading data: ${snapshot.error}",
                              ),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // Use dynamic to avoid strict Map<String, int> casting errors
                          final Map<String, dynamic> timerData =
                              snapshot.data?['timer'] ?? {};

                          final focus = timerData['focus'] ?? 0;
                          final rest = timerData['rest'] ?? 0;
                          final tasks = snapshot.data?['tasks'] ?? 0;

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.psychology_outlined,
                                      value:
                                          "${latestStress.toStringAsFixed(0)}%",
                                      label: "Current Stress",
                                      iconColor: Style.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.check_circle_outline,
                                      value: "$tasks",
                                      label: "Task Done this Week",
                                      iconColor: Style.orange,
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
                                      value:
                                          "${focus}min", // This will show 100min based on your DB
                                      label: "Focus Time",
                                      iconColor: Style.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: _buildStatCard(
                                      icon: Icons.bedtime_outlined,
                                      value:
                                          "${rest}min", // This will show 20min based on your DB
                                      label: "Rest Time",
                                      iconColor: Style.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      // --- DYNAMIC STATS GRID END ---
                      const SizedBox(height: 20),
                      if (stressVM.stressHistory.isNotEmpty) ...[
                        const Text(
                          "Stress Level Trend",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A3B32),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildStressChart(stressVM),
                        const SizedBox(height: 15),
                        _buildLatestStatusCard(latestStress),
                      ],
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
                            backgroundColor: Style.orange,
                            foregroundColor: Colors.white,
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
                            child: const Text(
                              "See All",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      _buildRecentJournalsList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Widget Builders ---

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
        color: const Color(0xFFFFF6EB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 40),
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
          ),
        ],
      ),
    );
  }

  Widget _buildStressChart(StressViewModel vm) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 20, left: 10, top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFF0E3)),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  int idx = val.toInt();
                  if (idx % 2 != 0 || idx < 0 || idx >= vm.stressHistory.length)
                    return const Text("");
                  return Text(
                    DateFormat('dd/MM').format(vm.stressHistory[idx].createdAt),
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: vm.stressHistory
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.totalPercentage))
                  .toList(),
              isCurved: true,
              color: Style.orange,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Style.orange.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestStatusCard(double score) {
    String status = "Tenang";
    Color color = Colors.green;
    IconData icon = Icons.sentiment_very_satisfied;

    if (score > 75) {
      status = "Overload";
      color = Colors.red;
      icon = Icons.warning_amber_rounded;
    } else if (score > 50) {
      status = "Stres Tinggi";
      color = Colors.orange;
      icon = Icons.sentiment_dissatisfied;
    } else if (score > 25) {
      status = "Stabil";
      color = Colors.blue;
      icon = Icons.sentiment_satisfied;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your current mental load is ${score.toStringAsFixed(1)}%. Take a short break if needed.",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJournalsList() {
    if (_journalViewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.deepOrange),
      );
    }

    if (_journalViewModel.journals.isEmpty) {
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

    final recentJournals = _journalViewModel.journals.take(2).toList();
    return Column(
      children: recentJournals
          .map(
            (journal) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildJournalCard(journal),
            ),
          )
          .toList(),
    );
  }

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
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(journal.date),
                    style: TextStyle(
                      color: const Color(0xFF4A3B32).withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
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
}
