import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/spacings.dart';

class AppThemeData {
  // ------------- FOR LIGHT MODE ------------
  static ThemeData themeLight = ThemeData(
    primaryColor: AppColors.kPrimary,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.kWhite,
    colorScheme: const ColorScheme.light(
      primary: AppColors.kPrimary,
      primaryContainer: AppColors.kPrimaryContainer,
      onPrimary: AppColors.kWhite,
      surface: AppColors.kWhite,
      onSurface: AppColors.kBlack,
      error: AppColors.moodRed,
      onError: AppColors.kWhite,
    ),

    iconButtonTheme: const IconButtonThemeData(style: ButtonStyle(iconSize: WidgetStatePropertyAll<double>(18))),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.kWhite),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kPrimary,
        foregroundColor: AppColors.kWhite,
        shape: const RoundedRectangleBorder(borderRadius: AppSpacings.defaultButtonBorderRadius),
      ),
    ),
  );
}
