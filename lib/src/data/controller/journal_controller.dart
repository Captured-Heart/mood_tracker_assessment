// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/mood_enums.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/data/repository/journal_repo_impl.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/journal_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';
import 'package:mood_tracker_assessment/utils/loader_util.dart';
import 'package:uuid/uuid.dart';

final journalProvider = AsyncNotifierProvider<JournalNotifier, JournalState>(() => JournalNotifier());

class JournalNotifier extends AsyncNotifier<JournalState> {
  late TextEditingController _addJournalController;
  late JournalRepository _journalRepository;

  @override
  Future<JournalState> build() async {
    _addJournalController = TextEditingController();
    _journalRepository = ref.read(journalRepoProvider);
    final allJournalList = await _journalRepository.getJournalsByUserId();
    return JournalState(journalList: allJournalList);
  }

  TextEditingController get addJournalController => _addJournalController;
  void _setIsLoading(bool isLoading) {
    state = AsyncValue.data(state.value!.copyWith(isLoading: isLoading));
  }

  void setErrorMessage(String? errorMessage) {
    _setIsLoading(false);
    state = AsyncValue.error(errorMessage ?? '', StackTrace.current);
  }

  void editJournal(MoodEntity journal) async {
    _addJournalController.text = journal.description;
    state = AsyncValue.data(
      state.value!.copyWith(addJournalMoodIndex: MoodEnum.getMoodEnum(journal.mood).index, journalToEdit: journal),
    );
  }

  void _onSuccessFul({bool isAddJournal = false, VoidCallback? onSuccess}) async {
    _setIsLoading(false);
    if (isAddJournal) {
      _addJournalController.clear();
    }
    final allJournalList = await _journalRepository.getJournalsByUserId();
    state = AsyncValue.data(state.value!.copyWith(journalList: allJournalList));
    onSuccess?.call();
  }

  void chooseJournalMood(int index) {
    state = AsyncValue.data(state.value!.copyWith(addJournalMoodIndex: index));
  }

  void resetJournalMoodSelection() async {
    final allJournalList = await _journalRepository.getJournalsByUserId();
    state = AsyncValue.data(JournalState(journalList: allJournalList));
  }

  Future<void> addJournal({VoidCallback? onSuccess}) async {
    _setIsLoading(true);
    final result = await simulateLoader(
      () => _journalRepository.addJournal(
        MoodEntity(
          mood: MoodEnum.fromIndex(state.value?.addJournalMoodIndex).moodName,
          id: const Uuid().v4(),
          description: _addJournalController.text.trim(),
          userId: CacheHelper.currentUser?.id,
          createdAt: DateTime.now().toIso8601String(),
        ),
      ),
    );
    return switch (result) {
      RepoError(message: var message) => setErrorMessage(message),
      RepoSuccess() => _onSuccessFul(onSuccess: onSuccess, isAddJournal: true),
    };
  }

  // delete journal
  Future<void> deleteJournal(String id, {VoidCallback? onSuccess}) async {
    _setIsLoading(true);
    final result = await simulateLoader(() => _journalRepository.deleteJournal(id), milliseconds: 10);
    return switch (result) {
      RepoError(message: var message) => setErrorMessage(message),
      RepoSuccess() => _onSuccessFul(onSuccess: onSuccess),
    };
  }

  // update journal
  Future<void> updateJournal({VoidCallback? onSuccess}) async {
    _setIsLoading(true);
    final result = await simulateLoader(
      () => _journalRepository.updateJournal(
        state.value!.journalToEdit!.copyWith(
          mood: MoodEnum.fromIndex(state.value?.addJournalMoodIndex).moodName,
          description: _addJournalController.text.trim(),
          createdAt: DateTime.now().toIso8601String(),
        ),
      ),
      milliseconds: 10,
    );
    return switch (result) {
      RepoError(message: var message) => setErrorMessage(message),
      RepoSuccess() => _onSuccessFul(onSuccess: onSuccess),
    };
  }
}

class JournalState {
  final bool isLoading;
  final int? addJournalMoodIndex;
  final String? errorMessage;
  final MoodEntity? journalToEdit;
  final List<MoodEntity>? journalList;

  JournalState({
    this.isLoading = false,
    this.addJournalMoodIndex,
    this.errorMessage,
    this.journalToEdit,
    this.journalList,
  });

  JournalState copyWith({
    bool? isLoading,
    int? addJournalMoodIndex,
    String? errorMessage,
    MoodEntity? journalToEdit,
    List<MoodEntity>? journalList,
  }) {
    return JournalState(
      isLoading: isLoading ?? this.isLoading,
      addJournalMoodIndex: addJournalMoodIndex ?? this.addJournalMoodIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      journalToEdit: journalToEdit ?? this.journalToEdit,
      journalList: journalList ?? this.journalList,
    );
  }
}
