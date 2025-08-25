import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/journal_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/journal_empty.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/journal_form.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/journal_list_tile.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/nav_pages_app_bar.dart';

class JournalView extends ConsumerWidget {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalProvider);
    final journalList = journalState.valueOrNull?.journalList;
    return Scaffold(
      appBar: NavBarPagesAppBar(title: TextConstants.journal.tr()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,

            constraints: BoxConstraints(maxHeight: context.deviceHeight(0.9)),
            elevation: 8,
            builder: (context) {
              return AddJournalForm();
            },
          );
        },
        child: Icon(Icons.note_add_outlined, size: 35),
      ),
      body: Builder(
        builder: (context) {
          if (journalList == null || journalList.isEmpty) {
            return JournalEmpty();
          }
          journalList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: journalList.length,
            itemBuilder: (context, index) {
              final journal = journalList[index];

              return JournalListTile(journal: journal).fadeInFromTop(delay: (index * 50).ms, animationDuration: 20.ms);
            },
          );
        },
      ),
    );
  }
}
