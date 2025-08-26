import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_tracker_assessment/constants/typedefs.dart';
import 'package:mood_tracker_assessment/hive_helper/hive_adapters.dart';
import 'package:mood_tracker_assessment/hive_helper/register_adapters.dart';
import 'package:mood_tracker_assessment/src/domain/entities/mood_entity.dart';
import 'package:mood_tracker_assessment/src/domain/entities/user_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/local_repository.dart';

enum HiveKeys { mood, user, sessionUser, threshHold, theme }

class CacheHelper {
  static late final LocalStorage<UserEntity> _userLocalModel;
  static late final LocalStorage<MoodEntity> _moodLocalModel;
  static late final LocalStorage<MoodEntity> _journalLocalModel;
  static late final LocalStorage<UserEntity> _sessionUserLocalModel;
  static late final LocalStorage<num> _threshHoldLocalModel;
  static late final LocalStorage<String> _themeLocalModel;

  static FutureVoid openHiveBoxes() async {
    await Hive.initFlutter();
    //i register adapters here
    registerAdapters();
    // i open the boxes (userEntity and moodEntity)
    _userLocalModel = LocalRepository<UserEntity>(await Hive.openBox(HiveAdapters.userEntity));
    _moodLocalModel = LocalRepository<MoodEntity>(await Hive.openBox(HiveAdapters.moodEntity));
    _journalLocalModel = LocalRepository<MoodEntity>(await Hive.openBox(HiveAdapters.journalEntity));
    _sessionUserLocalModel = LocalRepository<UserEntity>(await Hive.openBox(HiveAdapters.sessionUser));
    _threshHoldLocalModel = LocalRepository<num>(await Hive.openBox(HiveAdapters.threshHold));
    _themeLocalModel = LocalRepository<String>(await Hive.openBox(HiveAdapters.theme));
  }

  // Getters for the local models
  static LocalStorage<UserEntity> get userLocalModel => _userLocalModel;
  static LocalStorage<MoodEntity> get moodLocalModel => _moodLocalModel;
  static LocalStorage<UserEntity> get sessionUserLocalModel => _sessionUserLocalModel;
  static LocalStorage<MoodEntity> get journalLocalModel => _journalLocalModel;
  static LocalStorage<num> get threshHoldLocalModel => _threshHoldLocalModel;
  static LocalStorage<String> get themeLocalModel => _themeLocalModel;

  static UserEntity? get currentUser => _sessionUserLocalModel.read(HiveKeys.sessionUser.name);

  static Future<void> setClaimedThreshold(num threshHold) async {
    await _threshHoldLocalModel.write(HiveKeys.threshHold.name, threshHold);
  }

  // delete some num from threshold
  static Future<void> deleteSomeThreshold(num threshHold) async {
    var oldThreshold = getClaimedThreshold();
    if (oldThreshold < threshHold) return;
    oldThreshold -= threshHold;
    await _threshHoldLocalModel.write(HiveKeys.threshHold.name, oldThreshold);
  }

  static num getClaimedThreshold() {
    return _threshHoldLocalModel.read(HiveKeys.threshHold.name) ?? 0;
  }

  // set theme and get theme
  static Future<void> setTheme(String theme) async {
    await _themeLocalModel.write(HiveKeys.theme.name, theme);
  }

  static String? getTheme() {
    return _themeLocalModel.read(HiveKeys.theme.name);
  }
}
