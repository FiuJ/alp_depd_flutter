import 'package:flutter/material.dart';
import '../constants/colors.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedMinutes = 25;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(minutes: _selectedMinutes),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          color: AppColors.white,
          child: Column(
            children: [
              Text(
                'Focus Session',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              Text(
                'Stay focused and productive',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        // Timer Circle
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerCircle(context),
              const SizedBox(height: 48),
              // Duration Selection
              _buildDurationSelector(context),
              const SizedBox(height: 48),
              // Control Buttons
              _buildControlButtons(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCircle(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.primary,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_selectedMinutes.toString().padLeft(2, '0')}:00',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 64,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Minutes',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector(BuildContext context) {
    final durations = [15, 25, 45, 60];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: durations.length,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          final duration = durations[index];
          final isSelected = _selectedMinutes == duration;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: !_isRunning
                  ? () {
                      setState(() {
                        _selectedMinutes = duration;
                        _animationController.duration =
                            Duration(minutes: duration);
                        if (_animationController.isAnimating) {
                          _animationController.stop();
                        }
                        _animationController.reset();
                        _isRunning = false;
                      });
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.borderGray,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${duration}m',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.mediumGray,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_isRunning) {
                  _animationController.stop();
                } else {
                  _animationController.forward();
                }
                _isRunning = !_isRunning;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _isRunning ? 'Pause' : 'Start',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 120,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _animationController.stop();
                _animationController.reset();
                _isRunning = false;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Reset',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
