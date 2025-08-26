import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/controller/journal_controller.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/journal_form.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class JournalListTile extends ConsumerStatefulWidget {
  const JournalListTile({super.key, required this.journal});
  final MoodEntity journal;

  @override
  ConsumerState<JournalListTile> createState() => _JournalListTileState();
}

class _JournalListTileState extends ConsumerState<JournalListTile> with TickerProviderStateMixin {
  late SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    slidableController = SlidableController(this);
  }

  @override
  Widget build(BuildContext context) {
    final MoodEnum moodEnum = MoodEnum.getMoodEnum(widget.journal.mood);
    final journalCtrl = ref.read(journalProvider.notifier);
    return Row(
      spacing: 10,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MoodText.text(
              text: widget.journal.createdAt != null ? widget.journal.createdAt!.formatToDateNumberString : '',
              context: context,
              textStyle: context.textTheme.bodyLarge,
              fontWeight: FontWeight.bold,
            ),
            MoodText.text(
              text: widget.journal.createdAt != null ? widget.journal.createdAt!.formatToWeekdayString : '',
              context: context,
              textStyle: context.textTheme.bodyLarge,
            ),
          ],
        ),
        Expanded(
          child: Slidable(
            controller: slidableController,
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  //edit contact action
                  flex: 2,
                  onPressed: (_) {
                    journalCtrl.editJournal(widget.journal);
                    showModalBottomSheet(
                      context: context,
                      constraints: BoxConstraints(maxHeight: context.deviceHeight(0.9)),
                      elevation: 8,
                      builder: (context) {
                        return AddJournalForm(isEditJournal: true);
                      },
                    );
                  },
                  spacing: 4,
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.kGreen,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: TextConstants.edit.tr(),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
                SlidableAction(
                  //delete contact action
                  flex: 3,
                  onPressed: (_) {
                    journalCtrl.deleteJournal(
                      widget.journal.id,
                      onSuccess: () {
                        if (context.mounted) {
                          context.showSnackBar(
                            message: '${widget.journal.mood} Journal deleted successfully',
                            isError: false,
                          );
                        }
                      },
                    );
                  },
                  backgroundColor: AppColors.moodRed,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: TextConstants.delete.tr(),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
              ],
            ),
            key: ValueKey(widget.journal.id),
            child: Card(
              shadowColor: moodEnum.imageColor,
              surfaceTintColor: moodEnum.imageColor,
              // margin: EdgeInsets.only(bottom: 15),
              child: Row(
                spacing: 10,
                children: [
                  Image.asset(moodEnum.imagePath, width: 50, height: 50, fit: BoxFit.fill),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MoodText.text(
                                text: moodEnum.moodName.tr(),
                                context: context,
                                textStyle: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            MoodText.text(
                              text:
                                  widget.journal.createdAt != null ? widget.journal.createdAt!.formatToTimeString : '',
                              context: context,
                              color: AppColors.kGrey,
                              textStyle: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        MoodText.text(
                          text: widget.journal.description.tr(),
                          context: context,
                          color: AppColors.kGrey,
                          textStyle: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          isCenter: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ).padSymmetric(horizontal: 10, vertical: 15),
            ).onTap(
              onTap: () {
                // open bottomsheet to edit
              },
              tooltip: moodEnum.moodName,
            ),
          ),
        ),
      ],
    );
  }
}
