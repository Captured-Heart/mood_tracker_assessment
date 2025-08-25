import 'package:flutter/material.dart';

enum L10nEnum {
  enUS('🇺🇸', 'English', Locale('en', 'US')),
  deDE('🇩🇪', 'German', Locale('de', 'DE'));

  const L10nEnum(this.flag, this.lang, this.locale);
  final String flag;
  final String lang;
  final Locale locale;
  static L10nEnum fromLocale(Locale locale) {
    return L10nEnum.values.firstWhere(
      (e) => e.locale.languageCode == locale.languageCode && e.locale.countryCode == locale.countryCode,
      orElse: () => L10nEnum.enUS,
    );
  }
}
