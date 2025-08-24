import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/nav_pages_app_bar.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarPagesAppBar(title: 'Rewards'),
      body: Column(
        children: [
          // rewards dislay
        ],
      ),
    );
  }
}
