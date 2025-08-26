import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
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
  static List<BadgeEntity> badges = [
    BadgeEntity(
      threshold: 1,
      title: TextConstants.pearlBadge,
      description: TextConstants.earnedForFirstJournalEntry.tr(),
    ),
    BadgeEntity(
      threshold: 20,
      title: TextConstants.bronzeBadge,
      description: TextConstants.earnedForReaching.tr(args: ['20']),
    ),
    BadgeEntity(
      threshold: 30,
      title: TextConstants.silverBadge,
      description: TextConstants.earnedForReaching.tr(args: ['30']),
    ),
    BadgeEntity(
      threshold: 40,
      title: TextConstants.goldBadge,
      description: TextConstants.earnedForReaching.tr(args: ['40']),
    ),
    BadgeEntity(
      threshold: 50,
      title: TextConstants.platinumBadge,
      description: TextConstants.earnedForReaching.tr(args: ['50']),
    ),
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
          CacheHelper.setClaimedThreshold(badge.threshold);
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
}

class RewardData {
  final num totalEntries;
  final num totalPoints;
  final List<EarnedBadge> earnedBadges;
  final num streak;

  RewardData({required this.totalEntries, required this.totalPoints, required this.earnedBadges, required this.streak});
}
