import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';

enum MoodEnum {
  awesome(TextConstants.awesome, 10),
  good(TextConstants.good, 5),
  sad(TextConstants.sad, 3),
  horrible(TextConstants.horrible, 1);

  const MoodEnum(this.moodName, this.points);
  final String moodName;
  final num points;

  static MoodEnum getMoodEnum(String name) {
    return MoodEnum.values.firstWhere((mood) => mood.moodName.toLowerCase() == name.toLowerCase());
  }

  num get getClaimedThreshold {
    return switch (this) {
      MoodEnum.awesome => 10,
      MoodEnum.good => 5,
      MoodEnum.sad => 3,
      MoodEnum.horrible => 1,
    };
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
