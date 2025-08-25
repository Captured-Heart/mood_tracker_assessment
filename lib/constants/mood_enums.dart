import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';

enum MoodEnum {
  awesome('Awesome', 10),
  good('Good', 5),
  sad('Sad', 3),
  horrible('Horrible', 1);

  const MoodEnum(this.moodName, this.points);
  final String moodName;
  final num points;

  static MoodEnum getMoodEnum(String name) {
    return MoodEnum.values.firstWhere((mood) => mood.moodName.toLowerCase() == name.toLowerCase());
  }

  static MoodEnum fromIndex(int? index) {
    return MoodEnum.values[index ?? 0];
  }

  String get imagePath {
    return switch (this) {
      MoodEnum.awesome => AppImages.moodAwesome.pngPath,
      MoodEnum.good => AppImages.moodGood.pngPath,
      MoodEnum.sad => AppImages.moodSad.pngPath,
      MoodEnum.horrible => AppImages.moodHorrible.pngPath,
    };
  }

  Color get imageColor {
    return switch (this) {
      MoodEnum.awesome => AppColors.moodYellow,
      MoodEnum.good => AppColors.moodTeal,
      MoodEnum.sad => AppColors.moodPink,
      MoodEnum.horrible => AppColors.moodRed,
    };
  }
}
