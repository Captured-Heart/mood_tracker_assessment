import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/journal_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/local_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';

final journalRepoProvider = Provider<JournalRepository>((ref) {
  return JournalRepoImpl();
});

class JournalRepoImpl implements JournalRepository {
  final StreamController<List<MoodEntity>> _journalStreamController = StreamController.broadcast();

  Stream<List<MoodEntity>> get journalStream => _journalStreamController.stream;
  late LocalStorage<MoodEntity> _journalLocalRepository;

  JournalRepoImpl() {
    _journalLocalRepository = CacheHelper.journalLocalModel;
    _emitJournalList();
  }

  List<MoodEntity> get journalList => _journalLocalRepository.list;

  void _emitJournalList() {
    _journalStreamController.add(journalList);
  }

  @override
  Future<RepoResult> addJournal(MoodEntity journal) async {
    try {
      await _journalLocalRepository.write(journal.id, journal);
      _emitJournalList();
      return RepoResult.success(true);
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<RepoResult> deleteJournal(String id) async {
    try {
      await _journalLocalRepository.remove(id);
      _emitJournalList();
      return RepoResult.success(true);
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<RepoResult> updateJournal(MoodEntity journal) async {
    try {
      // the write method also updates, because i check if the id alsready exists & update
      await _journalLocalRepository.write(journal.id, journal);
      _emitJournalList();
      return RepoResult.success(true);
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<List<MoodEntity>> getJournalsByUserId() async {
    final currentUser = CacheHelper.currentUser;
    try {
      return journalList.where((journal) => journal.userId == currentUser?.id).toList();
    } catch (e) {
      return [];
    }
  }

  void dispose() {
    _journalStreamController.close();
  }
}
