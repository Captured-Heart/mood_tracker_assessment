import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/l10n_enum.dart';
import 'package:mood_tracker_assessment/constants/nav_routes.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/constants/typedefs.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/controller/auth_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/theme_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/primary_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/nav_pages_app_bar.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/profile_locale_widget.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/profile_theme_widget.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarPagesAppBar(title: TextConstants.profile.tr()),
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
                onTap: () => changeTheme(context),
                leading: Icon(Icons.sunny, color: AppColors.moodYellow),
                title: MoodText.text(
                  context: context,
                  text: TextConstants.changeTheme.tr(),
                  textStyle: context.textTheme.titleMedium,
                ),
                subtitle: MoodText.text(
                  context: context,
                  text: TextConstants.selectTheme.tr(),
                  textStyle: context.textTheme.bodyMedium,
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => changeLocaleModal(context),
                leading: Icon(Icons.language_outlined, color: AppColors.kGrey),
                title: MoodText.text(
                  context: context,
                  text: TextConstants.changeLocale.tr(),
                  textStyle: context.textTheme.titleMedium,
                ),
                subtitle: MoodText.text(
                  context: context,
                  text: TextConstants.changePreferredLanguage.tr(),
                  textStyle: context.textTheme.bodyMedium,
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.api, color: Colors.purple),
                title: MoodText.text(
                  context: context,
                  text: TextConstants.apiIntegrationDemo.tr(),
                  textStyle: context.textTheme.titleMedium,
                ),
                subtitle: MoodText.text(
                  context: context,
                  text: TextConstants.testRestApis.tr(),
                  textStyle: context.textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.kGrey),
                onTap: () {
                  context.pushNamed(NavRoutes.apiDemoRoute);
                },
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
                  title: TextConstants.signOut.tr(),
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

FutureVoid changeLocaleModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    elevation: 4,
    backgroundColor: context.theme.scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      side: BorderSide(color: context.theme.primaryColor, width: 0.6),
    ),
    builder: (context) => ProfileLocaleWidget(),
  );
}

FutureVoid changeTheme(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    elevation: 4,
    backgroundColor: context.theme.scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),

      side: BorderSide(color: context.theme.primaryColor, width: 0.6),
    ),
    builder: (context) => ChangeThemeWidget(),
  );
}
