import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/src/data/controller/mood_controller.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeMoodCalendar extends ConsumerStatefulWidget {
  const HomeMoodCalendar({super.key});

  @override
  ConsumerState<HomeMoodCalendar> createState() => _HomeMoodCalendarState();
}

class _HomeMoodCalendarState extends ConsumerState<HomeMoodCalendar> {
  late DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final moodState = ref.watch(moodProvider).valueOrNull;
    final moodList = moodState?.moods;
    inspect(moodList);

    //TODO: CUSTOMIZE TABLE LATER
    return Column(
      spacing: 10,
      children: [
        TableCalendar(
          focusedDay: moodState?.focusedDay ?? DateTime.now(),
          calendarFormat: CalendarFormat.week,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 1, 1),
          headerVisible: false,

          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            ref.read(moodProvider.notifier).getShowDescriptionForSelectedDay(selectedDay);
            // setState(() {
            //   // _selectedDay = selectedDay;
            //   _focusedDay = focusedDay;
            // });
          },
          rowHeight: 60,
          daysOfWeekHeight: 20,
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              return MoodText.text(
                context: context,
                text: DateFormat('E').format(day).substring(0, 3),
                isCenter: true,
                textStyle: context.textTheme.bodyLarge,
                color: isSameDay(day, (moodState?.focusedDay ?? _focusedDay)) ? AppColors.kPrimary : null,
                fontWeight:
                    isSameDay(day, (moodState?.focusedDay ?? _focusedDay)) ? FontWeight.bold : FontWeight.normal,
              ).padOnly(right: 5);
            },
            todayBuilder:
                (context, day, focusedDay) =>
                    MoodCalendarWidget(moodEntityList: moodList, dateTime: day, focusedDay: focusedDay),
            defaultBuilder: (context, day, focusedDay) {
              return MoodCalendarWidget(moodEntityList: moodList, dateTime: day, focusedDay: focusedDay);
            },
          ),
        ),

        DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: AppColors.kGrey), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MoodText.text(
                text: moodState?.showDescription ?? '',
                context: context,
                textStyle: context.textTheme.bodyMedium,
                // maxLines: 2,
              ).padSymmetric(horizontal: 10, vertical: 15),
            ],
          ),
        ),
      ],
    );
  }
}

class MoodCalendarWidget extends StatelessWidget {
  const MoodCalendarWidget({super.key, this.moodEntityList, required this.dateTime, required this.focusedDay});
  final DateTime dateTime, focusedDay;
  final List<MoodEntity>? moodEntityList;

  @override
  Widget build(BuildContext context) {
    final imagesForTheDays =
        moodEntityList?.where((mood) {
          if (mood.createdAt == null) return false;
          final moodDate = DateTime.tryParse(mood.createdAt!);
          if (moodDate == null) return false;
          return moodDate.year == dateTime.year && moodDate.month == dateTime.month && moodDate.day == dateTime.day;
        }).toList();
    bool isToday = isSameDay(dateTime, focusedDay);
    return SizedBox(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (imagesForTheDays == null || imagesForTheDays.isEmpty)
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.kGrey.withValues(alpha: 0.2),
                border: isToday ? Border.all(color: AppColors.kPrimary, width: 2) : null,
                image:
                    imagesForTheDays != null && imagesForTheDays.isNotEmpty
                        ? DecorationImage(
                          image: AssetImage(MoodEnum.getMoodEnum(imagesForTheDays.first.mood).imagePath),
                        )
                        : null,
              ),

              child:
                  imagesForTheDays != null && imagesForTheDays.isNotEmpty
                      ? Center()
                      : Center(
                        child: MoodText.text(
                          context: context,
                          text: "${dateTime.day}",
                          isCenter: true,
                          textStyle: context.textTheme.bodyLarge,
                        ).padAll(5),
                      ),
            ),
          ),
          // if (imagesForTheDays != null && imagesForTheDays.isNotEmpty)
          //   Expanded(
          //     child: Image.asset(MoodEnum.getMoodEnum(imagesForTheDays.first.mood).imagePath, fit: BoxFit.cover),
          //   ),
        ],
      ).padOnly(right: 5),
    );
  }
}
