import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/src/data/controller/journal_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/primary_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/textfield/app_textfield.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class AddJournalForm extends ConsumerWidget {
  const AddJournalForm({super.key, this.isEditJournal = false});
  final bool isEditJournal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalCtrl = ref.watch(journalProvider.notifier);
    final journalState = ref.watch(journalProvider);
    final addJournalMoodIndex = journalState.value?.addJournalMoodIndex;
    return Ink(
      color: MoodEnum.fromIndex(addJournalMoodIndex).imageColor.withValues(alpha: 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(MoodEnum.values.length, (index) {
                final mood = MoodEnum.values[index];
                final isNotSelected = addJournalMoodIndex != index;
                return Column(
                  spacing: 5,
                  children: [
                    Flexible(
                      child: ImageFiltered(
                        enabled: isNotSelected,
                        imageFilter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: Image.asset(mood.imagePath, height: !isNotSelected ? 100 : 70).onTap(
                          onTap: () {
                            journalCtrl.chooseJournalMood(index);
                          },
                          tooltip: mood.moodName,
                        ),
                      ),
                    ),
                    MoodText.text(
                      context: context,
                      text: mood.moodName,
                      textStyle: context.textTheme.titleMedium?.copyWith(
                        fontWeight: !isNotSelected ? FontWeight.w600 : FontWeight.w300,
                      ),
                    ),
                  ],
                ).padSymmetric(horizontal: 5);
              }),
            ),
          ),

          MoodTextfield(
            hintText: 'What\'s on your mind?',
            controller: journalCtrl.addJournalController,
            maxLines: 7,
            maxLength: 300,
            validator: (p0) => p0 == null || p0.isEmpty ? 'Please enter your journal' : null,
            inputFormatters: [],
          ),
          if (journalState.value?.errorMessage != null)
            MoodText.text(
              context: context,
              text: journalState.value?.errorMessage ?? '',
              textStyle: context.textTheme.bodyMedium,
              color: AppColors.moodRed,
              fontWeight: FontWeight.bold,
              isCenter: false,
            ),

          MoodPrimaryButton(
            state: journalState.value?.isLoading == true ? ButtonState.loading : ButtonState.loaded,
            onPressed: () {
              journalCtrl.setErrorMessage(null);
              if (addJournalMoodIndex == null) {
                journalCtrl.setErrorMessage('Please select a mood (Tap on Image)!!!');
                return;
              }
              if (journalCtrl.addJournalController.text.isEmpty) {
                journalCtrl.setErrorMessage('Please enter your journal!!!');
                return;
              }
              if (isEditJournal) {
                journalCtrl.updateJournal(
                  onSuccess: () {
                    context.showSnackBar(message: 'Journal updated successfully');
                    journalCtrl.resetJournalMoodSelection();
                    context.pop();
                  },
                );
              } else {
                journalCtrl.addJournal(
                  onSuccess: () {
                    context.showSnackBar(message: 'Journal added successfully');
                    journalCtrl.resetJournalMoodSelection();
                    context.pop();
                  },
                );
              }
            },
            title: isEditJournal ? 'Edit Journal' : 'Add Journal',
          ).padOnly(bottom: 5),
        ],
      ).padAll(20),
    );
  }
}
