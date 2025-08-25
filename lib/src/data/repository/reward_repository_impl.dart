import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/src/data/repository/journal_repo_impl.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/entities/reward_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/journal_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/rewards_repository.dart';

final rewardRepositoryProvider = Provider<RewardsRepository>((ref) {
  return RewardRepositoryImpl(ref.read(journalRepoProvider));
});

class RewardRepositoryImpl implements RewardsRepository {
  final StreamController<RewardData> _rewardStreamController = StreamController.broadcast();
  StreamSubscription? _journalSub;

  Stream<RewardData> get rewardStream => _rewardStreamController.stream;
  final JournalRepository _journalRepo;

  RewardRepositoryImpl(this._journalRepo) {
    // Listen to journal changes and update rewards
    if (_journalRepo is JournalRepoImpl) {
      _journalSub = _journalRepo.journalStream.listen((journals) async {
        final rewardData = await calculateRewardData(journals);
        _rewardStreamController.add(rewardData);
      });
    }
  }
  // Badges
  static const List<BadgeEntity> badges = [
    BadgeEntity(threshold: 1, title: 'Pearl Badge', description: 'Earned for first journal entry!'),
    BadgeEntity(threshold: 20, title: 'Bronze Badge', description: 'Earned for reaching 20 points!'),
    BadgeEntity(threshold: 30, title: 'Silver Badge', description: 'Earned for reaching 30 points!'),
    BadgeEntity(threshold: 40, title: 'Gold Badge', description: 'Earned for reaching 40 points!'),
    BadgeEntity(threshold: 50, title: 'Platinum Badge', description: 'Earned for reaching 50 points!'),
  ];

  @override
  Future<RewardData> calculateRewardData(List<MoodEntity> journals) async {
    num totalEntries = journals.length;
    num totalPoints = 0;
    num streak = 0;
    final List<EarnedBadge> earned = [];
    final Set<num> earnedThresholds = {};
    for (final journal in journals) {
      final mood = MoodEnum.getMoodEnum(journal.mood);
      totalPoints += mood.points;

      for (final badge in badges) {
        if (totalPoints >= badge.threshold && !earnedThresholds.contains(badge.threshold)) {
          earned.add(EarnedBadge(badge: badge, earnedAt: DateTime.parse(journal.createdAt!)));
          earnedThresholds.add(badge.threshold);
        }
      }
    }
    // earned Badges
    earned.sort((a, b) => b.badge.threshold.compareTo(a.badge.threshold));

    // Streak
    if (journals.isNotEmpty) {
      journals.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      streak = 1;
      DateTime? prev = DateTime.parse(journals.first.createdAt!);
      for (var journal in journals) {
        final curr = DateTime.parse(journal.createdAt!);
        if (prev?.difference(curr).inDays == 1) {
          streak++;
        } else if (prev?.difference(curr).inDays != null && prev!.difference(curr).inDays > 1) {
          break;
        }
        prev = curr;
      }
    }

    return RewardData(totalEntries: totalEntries, totalPoints: totalPoints, earnedBadges: earned, streak: streak);
  }

  void dispose() {
    _journalSub?.cancel();
    _rewardStreamController.close();
  }

  // // Total journal entries
  // @override
  // Future<num> getTotalJournalEntries() async {
  //   final journals = await _journalRepo.getJournalsByUserId();
  //   return journals.length;
  // }

  // // Total points earned
  // @override
  // Future<num> getTotalPoints() async {
  //   final journals = await _journalRepo.getJournalsByUserId();
  //   int total = 0;
  //   for (final journal in journals) {
  //     final mood = MoodEnum.getMoodEnum(journal.mood);
  //     total += mood.points as int;
  //   }
  //   return total;
  // }
  // @override
  // Future<List<BadgeEntity>> getEarnedBadges() async {
  //   final totalPoints = await getTotalPoints();
  //   return badges.where((badgeEntity) => totalPoints >= badgeEntity.threshold).toList();
  // }

  // @override
  // Future<List<EarnedBadge>> getEarnedBadgesWithDates() async {
  //   final journals = await _journalRepo.getJournalsByUserId();
  //   journals.sort((a, b) => DateTime.parse(a.createdAt!).compareTo(DateTime.parse(b.createdAt!)));

  //   num runningTotal = 0;
  //   final List<EarnedBadge> earned = [];
  //   final Set<num> earnedThresholds = {};

  //   for (final journal in journals) {
  //     final mood = MoodEnum.getMoodEnum(journal.mood);
  //     runningTotal += mood.points;

  //     for (final badge in badges) {
  //       if (runningTotal >= badge.threshold && !earnedThresholds.contains(badge.threshold)) {
  //         earned.add(EarnedBadge(badge: badge, earnedAt: DateTime.parse(journal.createdAt!)));
  //         earnedThresholds.add(badge.threshold);
  //       }
  //     }
  //   }
  //   earned.sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
  //   return earned;
  // }

  // //  Streak calculation
  // @override
  // Future<num> getStreak() async {
  //   final journals = await _journalRepo.getJournalsByUserId();
  //   if (journals.isEmpty) return 0;
  //   // Sort by date descending
  //   journals.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  //   num streak = 1;
  //   DateTime? prev = DateTime.parse(journals.first.createdAt!);

  //   for (var journal in journals) {
  //     final curr = DateTime.parse(journal.createdAt!);
  //     if (prev?.difference(curr).inDays == 1) {
  //       streak++;
  //     } else if (prev?.difference(curr).inDays != null && prev!.difference(curr).inDays > 1) {
  //       break;
  //     }
  //     prev = curr;
  //   }

  //   return streak;
  // }
}

class RewardData {
  final num totalEntries;
  final num totalPoints;
  final List<EarnedBadge> earnedBadges;
  final num streak;

  RewardData({required this.totalEntries, required this.totalPoints, required this.earnedBadges, required this.streak});
}
