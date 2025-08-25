import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/controller/auth_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/primary_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/nav_pages_app_bar.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarPagesAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(AppImages.noImageAvatar.pngPath, height: 100, width: 100, fit: BoxFit.cover),

            MoodText.text(
              context: context,
              text: CacheHelper.currentUser?.name ?? '',
              textStyle: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.sunny, color: Colors.grey),
                title: MoodText.text(context: context, text: 'Change Theme', textStyle: context.textTheme.titleMedium),
                subtitle: MoodText.text(
                  context: context,
                  text: 'Select theme',
                  textStyle: context.textTheme.bodyMedium,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.language_outlined, color: Colors.grey),
                title: MoodText.text(context: context, text: 'Change Locale', textStyle: context.textTheme.titleMedium),
                subtitle: MoodText.text(
                  context: context,
                  text: 'Change to your preferred language',
                  textStyle: context.textTheme.bodyMedium,
                ),
              ),
            ),
            const Spacer(),
            Consumer(
              builder: (context, ref, _) {
                final authState = ref.watch(authProvider);
                return MoodPrimaryButton(
                  state: authState.isLoading ? ButtonState.loading : ButtonState.loaded,
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                    context.popAllAndPushNamed('/');
                  },
                  title: 'Sign Out',
                  bGcolor: AppColors.moodRed,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
