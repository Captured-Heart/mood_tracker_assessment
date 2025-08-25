import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';

enum BadgeType {
  pearl('Pearl Badge', Icons.emoji_events, AppColors.moodPink),
  bronze('Bronze Badge', Icons.emoji_events, AppColors.moodRed),
  silver('Silver Badge', Icons.emoji_events, AppColors.moodTeal),
  gold('Gold Badge', Icons.emoji_events, AppColors.moodYellow),
  platinum('Platinum Badge', Icons.emoji_events, AppColors.kGreen);

  const BadgeType(this.name, this.iconData, this.color);
  final IconData iconData;
  final String name;
  final Color color;

  static BadgeType getBadgeType(String name) {
    return BadgeType.values.firstWhere(
      (type) => type.name.toLowerCase() == name.toLowerCase(),
      orElse: () => BadgeType.pearl,
    );
  }

  String get badgeName => name.replaceAll(' Badge', '');
}
