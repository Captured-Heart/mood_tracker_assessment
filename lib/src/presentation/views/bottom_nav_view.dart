import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/src/data/controller/bottom_nav_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/views/home_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/journal_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/profile_view.dart';
import 'package:mood_tracker_assessment/src/presentation/views/rewards_view.dart';

class BottomNavView extends ConsumerStatefulWidget {
  const BottomNavView({super.key});

  @override
  ConsumerState<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends ConsumerState<BottomNavView> {
  Widget bodyWidget({required int currentIndex}) {
    switch (currentIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const RewardsView();
      case 2:
        return const JournalView();
      case 3:
        return const ProfileView();

      default:
        return const HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavBarIndexProvider);
    return Scaffold(
      body: bodyWidget(currentIndex: currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(bottomNavBarIndexProvider.notifier).update((state) => index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Rewards'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
