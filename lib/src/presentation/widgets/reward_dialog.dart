import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/controller/reward_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/outline_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class RewardDialog extends ConsumerWidget {
  const RewardDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardState = ref.watch(rewardProvider.select((state) => state.valueOrNull?.earnedBadges.firstOrNull));
    inspect(rewardState);
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Image.asset(AppImages.rewardBackground.pngPath, fit: BoxFit.fill, height: 350, width: context.deviceWidth(1)),
        Positioned(
          top: 55,
          height: 220,
          left: context.deviceWidth(0.15),
          child: SizedBox(
            width: context.deviceWidth(0.7),
            child: Column(
              // spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Image.asset(AppImages.happyFace.pngPath, fit: BoxFit.fill, height: 70)),
                const SizedBox(height: 10),
                MoodText.text(
                  text: 'Congratulations!',
                  context: context,
                  textStyle: context.textTheme.titleLarge,
                  isCenter: true,
                ),
                MoodText.text(
                  text: 'You have just earned a new badge!',
                  context: context,
                  textStyle: context.textTheme.bodyLarge,
                  color: AppColors.kGrey,
                  isCenter: true,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),

                if (rewardState?.badge.title != null)
                  MoodText.text(
                    text: '"${rewardState?.badge.title}"',
                    context: context,
                    textStyle: context.textTheme.titleLarge,
                    isCenter: true,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                  ),
                const SizedBox(height: 15),

                MoodOutlineButton(
                  onPressed: () {
                    CacheHelper.setClaimedThreshold(rewardState?.badge.threshold ?? 0);
                    context.pop();
                  },
                  height: 35,
                  title: 'Claim Reward',
                ),
                // HomeMoodCalendar(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
