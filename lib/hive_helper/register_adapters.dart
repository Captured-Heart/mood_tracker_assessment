import 'package:hive/hive.dart';
import 'package:mood_tracker_assessment/src/domain/entities/user_entity.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';

void registerAdapters() {
	Hive.registerAdapter(UserEntityAdapter());
	Hive.registerAdapter(MoodEntityAdapter());
}
