// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:mood_tracker_assessment/hive_helper/fields/mood_entity_fields.dart';
import 'package:mood_tracker_assessment/hive_helper/hive_adapters.dart';
import 'package:mood_tracker_assessment/hive_helper/hive_types.dart';

part 'mood_entity.g.dart';

@HiveType(typeId: HiveTypes.moodEntity, adapterName: HiveAdapters.moodEntity)
class MoodEntity extends HiveObject {
  @HiveField(MoodEntityFields.id)
  final String id;
  @HiveField(MoodEntityFields.userId)
  final String? userId;
  @HiveField(MoodEntityFields.mood)
  final String mood;
  @HiveField(MoodEntityFields.description)
  final String description;
  @HiveField(MoodEntityFields.createdAt)
  final String? createdAt;

  MoodEntity({required this.id, this.userId, required this.mood, required this.description, this.createdAt});

  MoodEntity copyWith({String? id, String? userId, String? mood, String? description, String? createdAt}) {
    return MoodEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
