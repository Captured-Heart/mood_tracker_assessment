import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/l10n_enum.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class ProfileLocaleWidget extends StatelessWidget {
  const ProfileLocaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.deviceWidth(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children:
            context.supportedLocales.map((locale) {
              final L10nEnum localeEnum = L10nEnum.fromLocale(locale);
              final flag = localeEnum.flag;
              final lang = localeEnum.lang;

              return ListTile(
                onTap: () async {
                  await context.setLocale(locale);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    border: Border.all(color: context.theme.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(flag, textScaleFactor: 1.6),
                ),
                title: MoodText.text(
                  context: context,
                  text: lang,
                  textScaleFactor: 1.3,
                  textStyle: context.textTheme.bodyLarge,
                ),
              );
            }).toList(),
      ),
    );
  }
}
