import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_images.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeMoodCalendar extends StatefulWidget {
  const HomeMoodCalendar({super.key});

  @override
  State<HomeMoodCalendar> createState() => _HomeMoodCalendarState();
}

class _HomeMoodCalendarState extends State<HomeMoodCalendar> {
  late DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, String> _dayImages = {
    DateTime.utc(2025, 8, 1): AppImages.moodAwesome.pngPath,
    DateTime.utc(2025, 8, 2): AppImages.moodGood.pngPath,
    DateTime.utc(2025, 8, 3): AppImages.moodSad.pngPath,
  };
  @override
  Widget build(BuildContext context) {
    //TODO: CUSTOMIZE TABLE LATER
    return TableCalendar(
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 1, 1),
      headerVisible: false,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          String? imageUrl = _dayImages[DateTime.utc(day.year, day.month, day.day)];
          return DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.grey.shade200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${day.day}"),
                if (imageUrl != null) ...[const SizedBox(width: 4), Image.asset(imageUrl, width: 20, height: 20)],
              ],
            ),
          );
        },
      ),
    );
  }
}
