import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';

class MoodText {
  static Widget text({
    required String text,
    required BuildContext context,
    required TextStyle? textStyle,
    MoodColorSchemeEnum? colorSchemeEnum,
    bool isCenter = false,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    double? textScaleFactor,
  }) {
    return Text(
      text,
      style: textStyle?.copyWith(
        color: color ?? MoodColorSchemeEnum.getColorScheme(context, colorSchemeEnum: colorSchemeEnum),
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        letterSpacing: -0.3,
      ),
      textScaler: TextScaler.linear(textScaleFactor ?? 1.0),
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

enum MoodColorSchemeEnum {
  primary,
  onPrimary,
  primaryContainer,
  onPrimaryContainer,
  secondary,
  onSecondary,
  secondaryContainer,
  onSecondaryContainer,
  tertiary,
  onTertiary,
  tertiaryContainer,
  onTertiaryContainer,
  error,
  onError,
  errorContainer,
  onErrorContainer,
  background,
  onBackground,
  surface,
  onSurface,
  surfaceVariant,
  onSurfaceVariant,
  outline,
  outlineVariant,
  shadow,
  scrim,
  inverseSurface,
  onInverseSurface,
  inversePrimary;

  static Color getColorScheme(BuildContext context, {MoodColorSchemeEnum? colorSchemeEnum}) {
    final colorScheme = context.colorScheme;
    return switch (colorSchemeEnum ?? MoodColorSchemeEnum.onSurface) {
      MoodColorSchemeEnum.primary => colorScheme.primary,
      MoodColorSchemeEnum.onPrimary => colorScheme.onPrimary,
      MoodColorSchemeEnum.primaryContainer => colorScheme.primaryContainer,
      MoodColorSchemeEnum.onPrimaryContainer => colorScheme.onPrimaryContainer,
      MoodColorSchemeEnum.secondary => colorScheme.secondary,
      MoodColorSchemeEnum.onSecondary => colorScheme.onSecondary,
      MoodColorSchemeEnum.secondaryContainer => colorScheme.secondaryContainer,
      MoodColorSchemeEnum.onSecondaryContainer => colorScheme.onSecondaryContainer,
      MoodColorSchemeEnum.tertiary => colorScheme.tertiary,
      MoodColorSchemeEnum.onTertiary => colorScheme.onTertiary,
      MoodColorSchemeEnum.tertiaryContainer => colorScheme.tertiaryContainer,
      MoodColorSchemeEnum.onTertiaryContainer => colorScheme.onTertiaryContainer,
      MoodColorSchemeEnum.error => colorScheme.error,
      MoodColorSchemeEnum.onError => colorScheme.onError,
      MoodColorSchemeEnum.errorContainer => colorScheme.errorContainer,
      MoodColorSchemeEnum.onErrorContainer => colorScheme.onErrorContainer,
      MoodColorSchemeEnum.background => colorScheme.background,
      MoodColorSchemeEnum.onBackground => colorScheme.onBackground,
      MoodColorSchemeEnum.surface => colorScheme.surface,
      MoodColorSchemeEnum.onSurface => colorScheme.onSurface,
      MoodColorSchemeEnum.surfaceVariant => colorScheme.surfaceVariant,
      MoodColorSchemeEnum.onSurfaceVariant => colorScheme.onSurfaceVariant,
      MoodColorSchemeEnum.outline => colorScheme.outline,
      MoodColorSchemeEnum.outlineVariant => colorScheme.outlineVariant,
      MoodColorSchemeEnum.shadow => colorScheme.shadow,
      MoodColorSchemeEnum.scrim => colorScheme.scrim,
      MoodColorSchemeEnum.inverseSurface => colorScheme.inverseSurface,
      MoodColorSchemeEnum.onInverseSurface => colorScheme.onInverseSurface,
      MoodColorSchemeEnum.inversePrimary => colorScheme.inversePrimary,
    };
  }
}
