import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';

class AppSpacings {
  AppSpacings._();
  static const double k4 = 4;
  static const double k8 = 8;
  static const double k12 = 12;
  static const double k16 = 16;
  static const double k20 = 20;
  static const double k24 = 24;
  static const double k28 = 28;
  static const double k32 = 32;
  static const double k36 = 36;
  static const double k40 = 40;

  static const double webWidth = 1080;
  static const double elementSpacing = k20 * 0.5;
  static const double cardOutlineWidth = 0.25;

  static const defaultBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(k20),
    topRight: Radius.circular(k20),
    bottomLeft: Radius.circular(k20),
    bottomRight: Radius.circular(k20),
  );

  static const defaultButtonBorderRadius = BorderRadius.all(Radius.circular(50));
  static const borderRadiusk20All = BorderRadius.all(Radius.circular(AppSpacings.k20));
  static const borderRadiusk40All = BorderRadius.all(Radius.circular(AppSpacings.k40));

  static const defaultBorderRadiusTextField = BorderRadius.only(
    topLeft: Radius.circular(k12 * 0.5),
    topRight: Radius.circular(k12 * 0.5),
    bottomLeft: Radius.circular(k12 * 0.5),
    bottomRight: Radius.circular(k12 * 0.5),
  );

  static const defaultCircularRadius = BorderRadius.only(
    topLeft: Radius.circular(999),
    topRight: Radius.circular(999),
    bottomLeft: Radius.circular(999),
    bottomRight: Radius.circular(999),
  );

  static OutlineInputBorder outLineBorder = OutlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.kWhiteFade, width: 1.4),
  );

  static OutlineInputBorder disabledOutLineBorder = OutlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.kWhiteFade, width: 0.8),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.moodRed, width: 0.7),
  );

  static const OutlineInputBorder errorFocusedBorder = OutlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.moodRed, width: 1.2),
  );
  //
  // underline
  static const UnderlineInputBorder underlineEnabledBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.kTextGrey, width: 0.6),
  );

  static const UnderlineInputBorder underlineErrorBorder = UnderlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.moodRed, width: 0.7),
  );

  static const UnderlineInputBorder underlineErrorFocusedBorder = UnderlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.moodRed, width: 1.2),
  );

  static const UnderlineInputBorder disabledUnderlineBorder = UnderlineInputBorder(
    borderRadius: defaultBorderRadiusTextField,
    borderSide: BorderSide(color: AppColors.kWhiteFade, width: 0.8),
  );
}
