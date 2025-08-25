// Theme mode enum

// Theme notifier class
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);
  // getThemeMode();

  void setThemeMode(ThemeMode mode) {
    CacheHelper.setTheme(mode.name);
    state = mode;
  }

  void loadCurrentThemeMode() {
    String themeSaved = CacheHelper.getTheme() ?? ThemeMode.system.name;

    state = ThemeMode.values.where((element) => element.name == themeSaved).firstOrNull ?? ThemeMode.system;
  }

  //
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
