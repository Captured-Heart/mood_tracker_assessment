import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/src/data/controller/bottom_nav_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/home_mood_calendar.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/home_profile_pic_name.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/home_set_mood.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/journal_list_tile.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //profile pic and name
            Row(
              children: [
                Flexible(child: HomeProfilePicNameWidget()),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MoodText.text(
                      text: '+20',
                      context: context,
                      textStyle: context.textTheme.titleLarge,
                      fontWeight: FontWeight.w500,
                    ),
                    Image.asset(AppImages.coinBag.pngPath, height: 40, width: 40, fit: BoxFit.fill),
                  ],
                ),
              ],
            ),
            //
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // set mood
                    HomeSetMoodWidget(),

                    // HomeRewardDialog(),
                    // TableCalendar
                    HomeMoodCalendar(),
                    //descriptions
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.kGrey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MoodText.text(
                        text: 'the description of the date chosen' * 89,
                        context: context,
                        textStyle: context.textTheme.bodyMedium,
                        maxLines: 2,
                      ).padSymmetric(horizontal: 10, vertical: 15),
                    ),
                    //  recent activities
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MoodText.text(
                              text: 'Recent Activities',
                              context: context,
                              textStyle: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            MoodText.text(
                              text: 'See All',
                              context: context,
                              textStyle: context.textTheme.bodyMedium,
                            ).onTapWithoutAnimation(
                              onTap: () {
                                ref.read(bottomNavBarIndexProvider.notifier).update((state) => 2);

                                // context.pushNamed(NavRoutes.journalRoute);
                              },
                              tooltip: 'See all journal entries',
                            ),
                          ],
                        ),
                        // The list of recent activities
                        // ...List.generate(3, (index) {
                        //   return JournalListTile().fadeInFromTop(delay: (index * 50).ms, animationDuration: 20.ms);
                        // }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeRewardDialog extends StatelessWidget {
  const HomeRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppImages.rewardBackground.pngPath, fit: BoxFit.fill),
        Positioned(
          top: 55,
          left: context.deviceWidth(0.15),
          child: SizedBox(
            width: context.deviceWidth(0.6),
            child: Column(
              spacing: 10,
              children: [
                Image.asset(AppImages.happyFace.pngPath, fit: BoxFit.fill, height: 70),
                MoodText.text(
                  text: 'Congratulations!',
                  context: context,
                  textStyle: context.textTheme.titleLarge,
                  isCenter: true,
                ),
                MoodText.text(
                  text: 'You have been consistently tracking your mood!',
                  context: context,
                  textStyle: context.textTheme.bodyLarge,
                  isCenter: true,
                ),
                HomeMoodCalendar(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
