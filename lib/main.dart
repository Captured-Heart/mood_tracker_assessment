import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/nav_routes.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/presentation/views/add_mood_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/auth_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/bottom_nav_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/home_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/journal_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/splash_view.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.openHiveBoxes();
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.themeLight,
      darkTheme: AppThemeData.themeLight,
      home:
          // AuthView(),
          // HomeView(),
          SplashView(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return switch (settings.name) {
              NavRoutes.addMoodRoute => AddMoodView(),
              NavRoutes.splashRoute => SplashView(),
              NavRoutes.homeRoute => BottomNavView(),
              NavRoutes.journalRoute => JournalView(),
              NavRoutes.authRoute => AuthView(),
              _ => AddMoodView(),
            };
          },
        );
      },
    );
  }
}
