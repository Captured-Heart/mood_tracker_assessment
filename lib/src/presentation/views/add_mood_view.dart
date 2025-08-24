import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/src/data/controller/journal_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/mood_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/outline_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/primary_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/textfield/app_textfield.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class AddMoodView extends ConsumerWidget {
  const AddMoodView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodState = ref.watch(moodProvider);
    final moodCtrl = ref.read(moodProvider.notifier);
    final moodIndex = moodState.moodIndex;
    final moodEnum = MoodEnum.fromIndex(moodIndex);
    return Scaffold(
      backgroundColor: moodEnum.imageColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(moodEnum.imagePath, width: context.deviceWidth(0.5)),
                MoodText.text(
                  text: moodEnum.moodName,
                  context: context,
                  textStyle: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              spacing: 15,
              children:
                  MoodEnum.values.map((mood) {
                    return MoodOutlineButton(
                      onPressed: () {
                        moodCtrl.setMoodIndex(mood.index);
                      },
                      title: mood.moodName,
                      titleStyle: context.textTheme.bodyMedium,
                      bgColor: moodIndex == mood.index ? Colors.black : null,
                      textColor: moodIndex == mood.index ? AppColors.kWhite : AppColors.kBlack,
                    );
                  }).toList(),
            ),

            MoodPrimaryButton(
              onPressed: () {
                // TODO: ADD MOOD
                // context.pop();
                showModalBottomSheet(
                  context: context,

                  constraints: BoxConstraints(maxHeight: context.deviceHeight(0.9)),
                  elevation: 8,
                  builder: (context) {
                    return Ink(
                      color: moodEnum.imageColor.withValues(alpha: 0.1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 15,
                        children: [
                          MoodText.text(
                            context: context,
                            text: moodEnum.moodName,
                            textStyle: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),

                          MoodTextfield(
                            hintText: 'How is your day going??',
                            controller: moodCtrl.noteController,
                            maxLines: 5,
                            maxLength: 100,
                            validator: (p0) => p0 == null || p0.isEmpty ? 'Please enter your mood' : null,
                            inputFormatters: [],
                          ),

                          if (moodState.errorMessage != null)
                            MoodText.text(
                              context: context,
                              text: moodState.errorMessage ?? '',
                              textStyle: context.textTheme.bodyMedium,
                              color: AppColors.moodRed,
                              fontWeight: FontWeight.bold,
                              isCenter: false,
                            ),

                          MoodPrimaryButton(
                            state: moodState.isLoading ? ButtonState.loading : ButtonState.loaded,
                            onPressed: () {
                              moodCtrl.setErrorMessage(null);

                              if (moodCtrl.noteController.text.isEmpty) {
                                moodCtrl.setErrorMessage('Please enter a description for your mood!!!');
                                return;
                              }
                              moodCtrl.addMood(
                                onSuccess: () {
                                  context.showSnackBar(message: 'Mood added successfully');
                                  context.pop();
                                  context.pop();
                                },
                              );
                            },
                            title: 'Add Mood',
                          ).padOnly(bottom: 5),
                        ],
                      ).padAll(20),
                    );
                  },
                );
              },
              state: ButtonState.initial,
              title: 'Next',
              // textColor: AppColors.kWhite,
            ),
          ],
        ).padSymmetric(horizontal: 20),
      ),
    );
  }
}
