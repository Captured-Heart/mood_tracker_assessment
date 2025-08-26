import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/controller/confetti_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/reward_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/animations/confetti_widget.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/outline_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class RewardDialog extends ConsumerStatefulWidget {
  const RewardDialog({super.key});

  @override
  ConsumerState<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends ConsumerState<RewardDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(confettiProvider(10)).play();

      //
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: MoodConfettiWidget(
                    child: Image.asset(AppImages.happyFace.pngPath, fit: BoxFit.fill, height: 70),
                  ),
                ),
                const SizedBox(height: 10),
                MoodText.text(
                  text: TextConstants.congratulations.tr(),
                  context: context,
                  textStyle: context.textTheme.titleLarge,
                  color: AppColors.kBlack,
                  isCenter: true,
                ),
                MoodText.text(
                  text: TextConstants.earnedNewBadge.tr(),
                  context: context,
                  textStyle: context.textTheme.bodyLarge,
                  color: AppColors.kGrey,
                  isCenter: true,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),

                if (rewardState?.badge.title != null)
                  MoodText.text(
                    text: '"${rewardState?.badge.title.tr()}"',
                    context: context,
                    textStyle: context.textTheme.titleLarge,
                    isCenter: true,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBlack,

                    maxLines: 1,
                  ),
                const SizedBox(height: 15),

                MoodOutlineButton(
                  onPressed: () {
                    context.pop();
                  },
                  height: 35,
                  title: TextConstants.claimReward.tr(),
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
