import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';

abstract class JournalRepository {
  Future<RepoResult> addJournal(MoodEntity mood);
  Future<RepoResult> updateJournal(MoodEntity mood);
  Future<RepoResult> deleteJournal(String id);
  Future<List<MoodEntity>> getJournalsByUserId();
}
