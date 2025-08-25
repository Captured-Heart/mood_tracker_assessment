import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/badge_type_enums.dart';
import 'package:mood_tracker_assessment/src/domain/entities/reward_entity.dart';

class BadgeListTile extends StatelessWidget {
  const BadgeListTile({super.key, required this.badge});
  final EarnedBadge badge;

  @override
  Widget build(BuildContext context) {
    final badgeType = BadgeType.getBadgeType(badge.badge.title);
    final badgeColor = badgeType.color;
    final badgeIcon = badgeType.iconData;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: badgeColor.withValues(alpha: 0.2),
          child: Icon(badgeIcon, color: badgeColor),
        ),
        title: Text(badge.badge.title.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.badge.description.tr()),
            const SizedBox(height: 4),
            Text(
              'Earned: ${DateFormat('MMM d, y, hh:mm a').format(badge.earnedAt)}',
              style: const TextStyle(fontSize: 12, color: AppColors.kGrey),
            ),
          ],
        ),
      ),
    );
  }
}
