import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mood_tracker_assessment/src/data/repository/network/connectivity_repo_impl.dart';

final networkStreamProvider = StreamProvider<InternetStatus>((ref) async* {
  yield* ref.watch(connectivityRepositoryProvider).internetStatus();
});
