import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/src/data/repository/journal_repo_impl.dart';
import 'package:mood_tracker_assessment/src/data/repository/reward_repository_impl.dart';
import 'package:mood_tracker_assessment/src/domain/entities/reward_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/journal_repository.dart';

final rewardProvider = AutoDisposeAsyncNotifierProvider<RewardNotifier, RewardState>(RewardNotifier.new);

class RewardNotifier extends AutoDisposeAsyncNotifier<RewardState> {
  StreamSubscription? _rewardSub;
  late JournalRepository _journalRepo;

  @override
  Future<RewardState> build() async {
    _journalRepo = ref.read(journalRepoProvider);
    final rewardRepository = ref.read(rewardRepositoryProvider) as RewardRepositoryImpl;
    _loadRewards();
    final completer = Completer<RewardState>();
    _rewardSub = rewardRepository.rewardStream.listen((rewardData) {
      final newState = RewardState(
        isLoading: false,
        totalEntries: rewardData.totalEntries,
        totalPoints: rewardData.totalPoints,
        streak: rewardData.streak,
        earnedBadges: rewardData.earnedBadges,
      );
      state = AsyncValue.data(newState);
      if (!completer.isCompleted) {
        completer.complete(newState);
      }
    });
    ref.onDispose(() {
      _rewardSub?.cancel();
    });
    return completer.future;
  }

  Future<void> _loadRewards() async {
    final journals = await _journalRepo.getJournalsByUserId();
    final result = await ref.read(rewardRepositoryProvider).calculateRewardData(journals);
    state = AsyncValue.data(
      RewardState(
        totalEntries: result.totalEntries,
        totalPoints: result.totalPoints,
        streak: result.streak,
        earnedBadges: result.earnedBadges,
      ),
    );
  }
}

class RewardState {
  final bool isLoading;
  final num? totalEntries;
  final num? totalPoints;
  final num? streak;
  final List<EarnedBadge> earnedBadges;

  RewardState({
    this.isLoading = false,
    this.totalEntries = 0,
    this.totalPoints = 0,
    this.streak = 0,
    this.earnedBadges = const [],
  });

  RewardState copyWith({
    bool? isLoading,
    num? totalEntries,
    num? totalPoints,
    num? streak,
    List<EarnedBadge>? earnedBadges,
  }) {
    return RewardState(
      isLoading: isLoading ?? this.isLoading,
      totalEntries: totalEntries ?? this.totalEntries,
      totalPoints: totalPoints ?? this.totalPoints,
      streak: streak ?? this.streak,
      earnedBadges: earnedBadges ?? this.earnedBadges,
    );
  }
}
