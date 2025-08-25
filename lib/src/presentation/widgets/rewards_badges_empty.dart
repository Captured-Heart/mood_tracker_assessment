import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class RewardsBadgesEmpty extends StatelessWidget {
  const RewardsBadgesEmpty({super.key, this.title, this.description, this.icon});
  final String? title, description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon ?? Icons.emoji_events, size: 64, color: AppColors.kGrey),
            SizedBox(height: 16),
            MoodText.text(
              context: context,
              text: title ?? TextConstants.noBadgesYet.tr(),
              textStyle: context.textTheme.titleMedium,
              color: AppColors.kBlack.withValues(alpha: 0.5),
            ),
            SizedBox(height: 8),
            MoodText.text(
              context: context,
              text: description ?? TextConstants.startWritingJournalEntries.tr(),
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
