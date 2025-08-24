import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';

abstract class MoodRepository {
  Future<RepoResult> addMood(MoodEntity mood);
  Future<RepoResult> updateMood(MoodEntity mood);
  Future<RepoResult> deleteMood(MoodEntity mood);
  Future<List<MoodEntity>> getMoodsByUserId();
}
