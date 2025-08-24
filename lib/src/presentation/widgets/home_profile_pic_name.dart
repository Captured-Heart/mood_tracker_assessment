import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/controller/bottom_nav_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class HomeProfilePicNameWidget extends ConsumerWidget {
  const HomeProfilePicNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,

      horizontalTitleGap: 5,
      leading: Image.asset(AppImages.noImageAvatar.pngPath, height: 50, width: 50, fit: BoxFit.cover).onTap(
        onTap: () {
          ref.read(bottomNavBarIndexProvider.notifier).update((state) => 3);
        },
        tooltip: 'Profile',
      ),
      title: MoodText.text(
        text: '${DateTime.now().toIso8601String().getTimeOfDay()},',
        context: context,
        textStyle: context.textTheme.bodyMedium,
      ),
      subtitle: MoodText.text(
        text: '${CacheHelper.currentUser?.name}',
        context: context,
        textStyle: context.textTheme.titleMedium,
      ),
    );
  }
}
