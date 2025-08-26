import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/constants/nav_routes.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/mood_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/primary_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class HomeSetMoodWidget extends ConsumerWidget {
  const HomeSetMoodWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodState = ref.watch(moodProvider);
    final hasMoodForToday = moodState.valueOrNull?.hasMoodForToday ?? false;
    final moodForToday = moodState.valueOrNull?.moods.where((mood) => mood.createdAt?.isToday == true).firstOrNull;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.kGrey, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        minLeadingWidth: 10,
        titleAlignment: ListTileTitleAlignment.top,
        leading:
            moodForToday != null
                ? Image.asset(
                  MoodEnum.getMoodEnum(moodForToday.mood).imagePath,
                  width: 60,
                  height: 80,
                  fit: BoxFit.fill,
                )
                : SizedBox.shrink(),

        title: MoodText.text(
          text:
              hasMoodForToday
                  ? 'This is your mood for today: (${moodForToday != null ? MoodEnum.getMoodEnum(moodForToday.mood).moodName.tr() : ''})'
                  : 'How was your mood today?\nSet Your mood',
          context: context,
          textStyle: context.textTheme.bodyLarge,
        ),
        subtitle: Row(
          children: [
            if (!hasMoodForToday)
              MoodPrimaryButton(
                    onPressed: () {
                      context.pushNamed(NavRoutes.addMoodRoute);
                    },
                    title: TextConstants.setMood.tr(),
                    height: 40,
                    bGcolor: AppColors.kGreen,
                    isTitleShrinked: true,
                  )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(begin: 0.95, end: 1.1, duration: 1000.ms, curve: Curves.easeInOut),
          ],
        ).padOnly(top: 10),
      ),
    );
  }
}
