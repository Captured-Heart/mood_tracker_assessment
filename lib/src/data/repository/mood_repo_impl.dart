import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/local_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/mood_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';

final moodRepoProvider = Provider<MoodRepository>((ref) {
  return MoodRepoImpl();
});

class MoodRepoImpl implements MoodRepository {
  late LocalStorage<MoodEntity> _moodLocalRepository;

  MoodRepoImpl() {
    _moodLocalRepository = CacheHelper.moodLocalModel;
  }

  List<MoodEntity> get moodList => _moodLocalRepository.list;

  @override
  Future<RepoResult> addMood(MoodEntity mood) async {
    try {
      // check if mood already exists
      final myMoodList = await getMoodsByUserId();
      if (myMoodList.any((existingMood) => existingMood.createdAt?.isToday == true)) {
        return RepoResult.error('You cannot create mood for today');
      }
      await _moodLocalRepository.write(mood.id, mood);
      return RepoResult.success(true);
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<RepoResult> deleteMood(MoodEntity mood) async {
    try {
      await _moodLocalRepository.remove(mood.id);
      return RepoResult.success(true);
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<RepoResult> updateMood(MoodEntity mood) async {
    try {
      // the write method also updates, because i check if the id alsready exists & update
      await _moodLocalRepository.write(mood.id, mood);
      return RepoResult.success(true);
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<List<MoodEntity>> getMoodsByUserId() async {
    final currentUser = CacheHelper.currentUser;
    try {
      return moodList.where((mood) => mood.userId == currentUser?.id).toList();
    } catch (e) {
      return [];
    }
  }
}
