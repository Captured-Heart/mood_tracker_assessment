import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
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
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // ref.read(rewardProvider.notifier).loadRewards();
  //   });
  // }

  final ScrollController _scrollController = ScrollController();

  // IconData _getBadgeIcon(gam.BadgeType type) {
  @override
  Widget build(BuildContext context) {
    final rewardVal = ref.watch(rewardProvider);
    return Scaffold(
      appBar: NavBarPagesAppBar(title: "Rewards"),
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
                  text: 'Your Stats',
                  textStyle: context.textTheme.titleLarge,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RewardStatsCard(
                        title: 'Journal Entries',
                        value: rewardState?.totalEntries?.toString() ?? '0',
                        icon: Icons.book,
                        color: Colors.blue,
                      ).onTap(
                        onTap: () {
                          ref.read(bottomNavBarIndexProvider.notifier).update((state) => 2);
                        },
                        tooltip: 'View Journal Entries',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RewardStatsCard(
                        title: 'Points Earned',
                        value: rewardState?.totalPoints?.toString() ?? '0',
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
                        title: 'Current Streak',
                        value: rewardState?.streak?.toString() ?? '0',
                        icon: Icons.local_fire_department,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RewardStatsCard(
                        title: 'Badges Earned',
                        value: rewardState?.earnedBadges.length.toString() ?? '0',
                        icon: Icons.emoji_events,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                MoodText.text(
                  context: context,
                  text: 'Your Badges',
                  textStyle: context.textTheme.titleLarge,
                  fontWeight: FontWeight.bold,
                ),

                rewardState?.earnedBadges == null || (rewardState?.earnedBadges.isEmpty ?? true)
                    ? RewardsBadgesEmpty()
                    : ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: rewardState?.earnedBadges.length ?? 0,
                      itemBuilder: (context, index) {
                        final badge = rewardState?.earnedBadges[index];
                        if (badge == null) return const SizedBox.shrink();
                        return BadgeListTile(badge: badge);
                      },
                    ),
              ],
            ),
          );
        },
        error: (e, st) => Text('Error: $e'),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
