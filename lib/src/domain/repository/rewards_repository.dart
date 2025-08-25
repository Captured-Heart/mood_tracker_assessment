import 'package:mood_tracker_assessment/src/data/repository/reward_repository_impl.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';

abstract class RewardsRepository {
  Future<RewardData> calculateRewardData(List<MoodEntity> journals);
}
