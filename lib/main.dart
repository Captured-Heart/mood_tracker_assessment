import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/nav_routes.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/hive_helper/register_adapters.dart';
import 'package:mood_tracker_assessment/src/data/controller/theme_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/views/add_mood_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/api_demo_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/auth_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/bottom_nav_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/home_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/journal_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/splash_view.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await CacheHelper.openHiveBoxes();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        saveLocale: true,
        path: 'assets/l10n',
        fallbackLocale: const Locale('en', 'US'),

        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      // key: ValueKey(context.locale),
      restorationScopeId: 'app',
      title: TextConstants.moodTracker.tr(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: themeMode,

      onGenerateTitle: (context) => TextConstants.moodTracker.tr(),
      theme: AppThemeData.themeLight,
      darkTheme: AppThemeData.themeDark,
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
              NavRoutes.apiDemoRoute => ApiDemoView(),
              _ => SplashView(),
            };
          },
        );
      },
    );
  }
}
