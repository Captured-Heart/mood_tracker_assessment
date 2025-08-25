import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/bottom_nav_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/journal_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/reward_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/home_mood_calendar.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/home_profile_pic_name.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/home_set_mood.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/journal_list_tile.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/reward_dialog.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/rewards_badges_empty.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalProvider);
    final rewardPoints = ref.watch(rewardProvider.select((state) => state.valueOrNull?.totalPoints));
    final journalList = journalState.valueOrNull?.journalList;

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 5,
                  children: [
                    MoodText.text(
                      text: '+$rewardPoints',
                      context: context,
                      textStyle: context.textTheme.bodyLarge,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(Icons.stars, size: 28, color: AppColors.moodYellow),
                  ],
                ).onTap(
                  onTap: () {
                    ref.read(bottomNavBarIndexProvider.notifier).update((state) => 1);
                  },
                  tooltip: TextConstants.viewRewards.tr(),
                ),
                const SizedBox(width: 8),
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

                    // RewardDialog(),
                    // TableCalendar
                    HomeMoodCalendar(),
                    //descriptions

                    //  recent activities
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MoodText.text(
                              text: TextConstants.recentActivities.tr(),
                              context: context,
                              textStyle: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            MoodText.text(
                              text: TextConstants.seeAll.tr(),
                              context: context,
                              textStyle: context.textTheme.bodyMedium,
                            ).onTapWithoutAnimation(
                              onTap: () {
                                ref.read(bottomNavBarIndexProvider.notifier).update((state) => 2);
                              },
                              tooltip: TextConstants.seeAllJournalEntries.tr(),
                            ),
                          ],
                        ),

                        // The list of recent activities
                        journalList == null || journalList.isEmpty
                            ? RewardsBadgesEmpty(
                              title: TextConstants.noJournalEntriesYet.tr(),
                              description: TextConstants.startWritingJournalEntries.tr(),
                              icon: Icons.book,
                            ).onTap(
                              onTap: () {
                                ref.read(bottomNavBarIndexProvider.notifier).update((state) => 2);
                              },
                              tooltip: TextConstants.addJournalEntry.tr(),
                            )
                            : Column(
                              children: List.generate(journalList.take(4).length, (index) {
                                final journal = journalList[index];

                                return JournalListTile(
                                  journal: journal,
                                ).fadeInFromTop(delay: (index * 50).ms, animationDuration: 20.ms);
                              }),
                            ),
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
