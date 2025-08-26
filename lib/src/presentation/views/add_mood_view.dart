import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
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
    final moodIndex = moodState.valueOrNull?.moodIndex;
    final moodEnum = MoodEnum.fromIndex(moodIndex);
    return Scaffold(
      backgroundColor: moodEnum.imageColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.deviceHeight(1),
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
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      enableDrag: true,
                      elevation: 8,
                      builder: (context) {
                        return Consumer(
                          builder: (context, ref, _) {
                            final moodSheetState = ref.watch(moodProvider);

                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: SingleChildScrollView(
                                child: Ink(
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
                                        hintText: TextConstants.howIsYourDayGoing.tr(),
                                        controller: moodCtrl.noteController,
                                        maxLines: 5,
                                        maxLength: 100,
                                        validator:
                                            (p0) =>
                                                p0 == null || p0.isEmpty
                                                    ? TextConstants.pleaseEnterYourMood.tr()
                                                    : null,
                                        inputFormatters: [],
                                      ),

                                      if (moodSheetState.value?.errorMessage != null)
                                        MoodText.text(
                                          context: context,
                                          text: moodSheetState.value?.errorMessage ?? '',
                                          textStyle: context.textTheme.bodyMedium,
                                          color: AppColors.moodRed,
                                          fontWeight: FontWeight.bold,
                                          isCenter: false,
                                        ),

                                      MoodPrimaryButton(
                                        state:
                                            moodSheetState.value?.isLoading == true
                                                ? ButtonState.loading
                                                : ButtonState.loaded,
                                        onPressed: () {
                                          moodCtrl.setErrorMessage(null);

                                          if (moodCtrl.noteController.text.isEmpty) {
                                            moodCtrl.setErrorMessage(TextConstants.pleaseEnterDescriptionMood.tr());
                                            return;
                                          }
                                          moodCtrl.addMood(
                                            onSuccess: () {
                                              context.showSnackBar(message: TextConstants.moodAddedSuccessfully.tr());
                                              context.pop();
                                              context.pop();
                                            },
                                          );
                                        },
                                        title: TextConstants.addMood.tr(),
                                      ).padOnly(bottom: 5),
                                    ],
                                  ).padAll(20),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  state: ButtonState.initial,
                  title: TextConstants.next.tr(),
                  // textColor: AppColors.kWhite,
                ),
              ],
            ).padSymmetric(horizontal: 20),
          ),
        ),
      ),
    );
  }
}
