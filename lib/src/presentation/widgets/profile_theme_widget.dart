import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/theme_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class ChangeThemeWidget extends ConsumerWidget {
  const ChangeThemeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.deviceWidth(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
              context.pop(context);
            },
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                border: Border.all(color: context.theme.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.sunny, size: 30, color: AppColors.moodYellow),
            ),
            title: MoodText.text(
              context: context,
              text: TextConstants.lightMode.tr(),
              textScaleFactor: 1.3,
              textStyle: context.textTheme.bodyLarge,
            ),
            trailing: Radio(
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(value as ThemeMode);
                context.pop(context);
              },
            ),
          ),

          // dark mode
          ListTile(
            onTap: () async {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
              context.pop(context);
            },
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                border: Border.all(color: context.theme.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.dark_mode, size: 30, color: AppColors.moodYellow),
            ),
            title: MoodText.text(
              context: context,
              text: TextConstants.darkMode.tr(),
              textScaleFactor: 1.3,
              textStyle: context.textTheme.bodyLarge,
            ),
            trailing: Radio(
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
                context.pop(context);
              },
            ),
          ),
          // system
          ListTile(
            onTap: () async {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
              context.pop(context);
            },
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                border: Border.all(color: context.theme.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.sunny_snowing, size: 30, color: AppColors.moodYellow),
            ),
            title: MoodText.text(
              context: context,
              text: TextConstants.systemMode.tr(),
              textScaleFactor: 1.3,
              textStyle: context.textTheme.bodyLarge,
            ),
            trailing: Radio(
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
                context.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
