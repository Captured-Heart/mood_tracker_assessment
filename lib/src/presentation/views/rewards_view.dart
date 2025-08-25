import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/bottom_nav_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/reward_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/nav_pages_app_bar.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/reward_stats_card.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/rewards_badge_list_tile.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/rewards_badges_empty.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class RewardsView extends ConsumerStatefulWidget {
  const RewardsView({super.key});

  @override
  ConsumerState<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends ConsumerState<RewardsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final rewardVal = ref.watch(rewardProvider);
    return Scaffold(
      appBar: NavBarPagesAppBar(title: TextConstants.rewards.tr()),
      body: rewardVal.when(
        data: (data) {
          final rewardState = data;
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                MoodText.text(
                  context: context,
                  text: TextConstants.yourStats.tr(),
                  textStyle: context.textTheme.titleLarge,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RewardStatsCard(
                        title: TextConstants.journalEntries.tr(),
                        value: rewardState.totalEntries?.toString() ?? '0',
                        icon: Icons.book,
                        color: Colors.blue,
                      ).onTap(
                        onTap: () {
                          ref.read(bottomNavBarIndexProvider.notifier).update((state) => 2);
                        },
                        tooltip: TextConstants.viewJournalEntries.tr(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RewardStatsCard(
                        title: TextConstants.pointsEarned.tr(),
                        value: rewardState.totalPoints?.toString() ?? '0',
                        icon: Icons.stars,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: RewardStatsCard(
                        title: TextConstants.currentStreak.tr(),
                        value: rewardState.streak?.toString() ?? '0',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RewardStatsCard(
                        title: TextConstants.badgesEarned.tr(),
                        value: rewardState.earnedBadges.length.toString() ?? '0',
                        icon: Icons.emoji_events,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                MoodText.text(
                  context: context,
                  text: TextConstants.yourBadges.tr(),
                  textStyle: context.textTheme.titleLarge,
                  fontWeight: FontWeight.bold,
                ),

                rewardState.earnedBadges == null || (rewardState.earnedBadges.isEmpty ?? true)
                    ? RewardsBadgesEmpty()
                    : ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: rewardState.earnedBadges.length ?? 0,
                      itemBuilder: (context, index) {
                        final badge = rewardState.earnedBadges[index];
                        if (badge == null) return const SizedBox.shrink();
                        return BadgeListTile(badge: badge);
                      },
                    ),
              ],
            ),
          );
        },
        error: (e, st) => Text('${TextConstants.error.tr()}: $e'),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
