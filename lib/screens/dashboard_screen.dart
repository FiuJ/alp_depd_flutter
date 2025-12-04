import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          _buildHeader(context),
          // Condition Result Grid
          _buildConditionGrid(context),
          // Start Session Button
          _buildStartSessionButton(context),
          // Your Journal Section
          _buildJournalSection(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you today?',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 24),
          Center(
            child: Image.asset(
              'assets/characters/character.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(Icons.sentiment_satisfied_alt,
                      size: 60, color: AppColors.primary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionGrid(BuildContext context) {
    final conditions = [
      _ConditionItem(
        title: 'Stress Level',
        value: '24%',
        subtitle: 'Stress Level',
        icon: Icons.psychology,
        color: AppColors.primary,
      ),
      _ConditionItem(
        title: 'Task Done',
        value: '12',
        subtitle: 'Task Done this Week',
        icon: Icons.check_circle,
        color: AppColors.primary,
      ),
      _ConditionItem(
        title: 'Focus Time',
        value: '103min',
        subtitle: 'Focus Time',
        icon: Icons.timer,
        color: AppColors.primary,
      ),
      _ConditionItem(
        title: 'Rest Time',
        value: '35min',
        subtitle: 'Rest Time',
        icon: Icons.self_improvement,
        color: AppColors.primary,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16),
            child: Text(
              'Your Condition Result',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: conditions.length,
            itemBuilder: (context, index) {
              return _ConditionCard(item: conditions[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartSessionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session started!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Start Session',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildJournalSection(BuildContext context) {
    final journalItems = [
      {
        'date': '12 November 2025',
        'title': 'My day looks nice',
        'description':
            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at...',
      },
      {
        'date': '11 November 2025',
        'title': 'Feeling great today',
        'description':
            'Had a productive day with lots of accomplishments and positive interactions.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Journal',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: journalItems.length,
            itemBuilder: (context, index) {
              final item = journalItems[index];
              return _JournalCard(
                date: item['date']!,
                title: item['title']!,
                description: item['description']!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ConditionItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  _ConditionItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _ConditionCard extends StatelessWidget {
  final _ConditionItem item;

  const _ConditionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(item.icon, color: item.color, size: 32),
            Text(
              item.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: item.color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final String date;
  final String title;
  final String description;

  const _JournalCard({
    required this.date,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppColors.mediumGray),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
