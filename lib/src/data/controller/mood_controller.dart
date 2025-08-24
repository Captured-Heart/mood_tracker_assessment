import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/data/repository/mood_repo_impl.dart';
import 'package:mood_tracker_assessment/src/domain/repository/mood_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';
import 'package:mood_tracker_assessment/utils/loader_util.dart';
import 'package:uuid/uuid.dart';

final moodProvider = AsyncNotifierProvider<MoodNotifier, MoodState>(() {
  return MoodNotifier();
});

class MoodNotifier extends AsyncNotifier<MoodState> {
  late MoodRepository _moodRepository;
  late TextEditingController _noteController;

  @override
  Future<MoodState> build() async {
    _moodRepository = ref.read(moodRepoProvider);
    _noteController = TextEditingController();
    final allMoods = await _moodRepository.getMoodsByUserId();
    final hasMoodForToday = allMoods.any((mood) => mood.createdAt?.isToday == true);
    return MoodState(moods: allMoods, hasMoodForToday: hasMoodForToday);
  }

  TextEditingController get noteController => _noteController;

  void setErrorMessage(String? errorMessage) {
    _setIsLoading(false);
    state = AsyncValue.error(errorMessage ?? '', StackTrace.current);
  }

  void setMoodIndex(int index) {
    state = AsyncValue.data(state.value!.copyWith(moodIndex: index));
  }

  void _setIsLoading(bool isLoading) {
    state = AsyncValue.data(state.value!.copyWith(isLoading: isLoading));
  }

  void _setErrorMessage(String? errorMessage) {
    _setIsLoading(false);
    state = AsyncValue.error(errorMessage ?? '', StackTrace.current);
  }

  void _onSuccess(VoidCallback? onSuccess) {
    _setIsLoading(false);
    _noteController.clear();
    onSuccess?.call();
  }

  Future<void> addMood({VoidCallback? onSuccess}) async {
    _setIsLoading(true);
    final moodEntity = MoodEntity(
      id: Uuid().v4(),
      mood: MoodEnum.fromIndex(state.value?.moodIndex).moodName,
      description: _noteController.text,
      createdAt: DateTime.now().toIso8601String(),
      userId: CacheHelper.currentUser?.id,
    );
    final result = await simulateLoader(() => _moodRepository.addMood(moodEntity), milliseconds: 10);
    inspect(result);

    return switch (result) {
      RepoError(message: var message) => _setErrorMessage(message),
      RepoSuccess() => _onSuccess(onSuccess),
    };
  }

  Future<void> updateMood(MoodEntity mood, {VoidCallback? onSuccess}) async {
    _setIsLoading(true);
    final result = await simulateLoader(() => _moodRepository.updateMood(mood));
    return switch (result) {
      RepoError(message: var message) => _setErrorMessage(message),
      RepoSuccess() => _onSuccess(onSuccess),
    };
  }

  Future<void> deleteMood(MoodEntity mood, {VoidCallback? onSuccess}) async {
    _setIsLoading(true);
    final result = await simulateLoader(() => _moodRepository.deleteMood(mood));
    return switch (result) {
      RepoError(message: var message) => _setErrorMessage(message),
      RepoSuccess() => _onSuccess(onSuccess),
    };
  }

  Future<void> getMoodsByUserId() async {
    _setIsLoading(true);
    try {
      final moods = await _moodRepository.getMoodsByUserId();
      state = AsyncValue.data(state.value!.copyWith(moods: moods, isLoading: false));
    } catch (e) {
      _setErrorMessage(e.toString());
    }
  }
}

class MoodState {
  final bool isLoading;
  final String? errorMessage;
  final int? moodIndex;
  final bool hasMoodForToday;
  final List<MoodEntity> moods;

  MoodState({
    this.isLoading = false,
    this.errorMessage,
    this.moods = const [],
    this.moodIndex,
    this.hasMoodForToday = false,
  });

  MoodState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MoodEntity>? moods,
    int? moodIndex,
    bool? hasMoodForToday,
  }) {
    return MoodState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      moods: moods ?? this.moods,
      moodIndex: moodIndex ?? this.moodIndex,
      hasMoodForToday: hasMoodForToday ?? this.hasMoodForToday,
    );
  }
}
