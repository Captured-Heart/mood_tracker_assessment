import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class JournalEmpty extends StatelessWidget {
  const JournalEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          MoodText.text(
            context: context,
            text: 'No Journal Available!',
            textStyle: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          MoodText.text(
            context: context,
            text: 'Click on the button below to add a journal entry',
            textStyle: context.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            isCenter: true,
          ),
        ],
      ),
    );
  }
}
