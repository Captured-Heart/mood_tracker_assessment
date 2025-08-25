import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class RewardStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const RewardStatsCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            MoodText.text(
              context: context,
              text: value,
              textStyle: context.textTheme.titleLarge,
              fontWeight: FontWeight.bold,
              maxLines: 1,
            ),
            MoodText.text(
              context: context,
              text: title,
              textStyle: context.textTheme.bodyMedium,
              color: AppColors.kGrey,
              isCenter: true,
            ),
          ],
        ),
      ),
    );
  }
}
