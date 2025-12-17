part of 'pages.dart';

class Journalhistory extends StatefulWidget {
  const Journalhistory({super.key});

  @override
  State<Journalhistory> createState() => _JournalhistoryState();
}

class _JournalhistoryState extends State<Journalhistory> {
  // 1. Initialize ViewModel
  final JournalViewModel _viewModel = JournalViewModel();

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

  // Helper to format date nicely (e.g., 2025-11-12 -> 12 November 2025)
  String _formatDate(DateTime date) {
    const List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    // 3. Wrap with ListenableBuilder to listen for data changes
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
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
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    // Handle Loading State
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
    }

    // Handle Error State
    if (_viewModel.errorMessage != null) {
      return Center(child: Text(_viewModel.errorMessage!));
    }

    // Handle Empty State
    if (_viewModel.journals.isEmpty) {
      return const Center(
        child: Text(
          "No journals found yet.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Handle Success State (List)
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _viewModel.journals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final journal = _viewModel.journals[index];
        return _buildJournalCard(journal);
      },
    );
  }

  // Updated to accept JournalModel instead of Map
  Widget _buildJournalCard(JournalModel journal) {
    // Wrap Container with GestureDetector
    return GestureDetector(
      onTap: () {
        // Navigate to Detail Page
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
                    maxLines: 1, // Limit title in history view
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
                    maxLines: 2, // Limit content in history view
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