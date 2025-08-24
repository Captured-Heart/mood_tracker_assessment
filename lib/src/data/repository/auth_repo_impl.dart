import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/hive_helper/cache_helper.dart';
import 'package:mood_tracker_assessment/src/domain/entities/user_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/auth_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/local_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepoImpl();
});

class AuthRepoImpl implements AuthRepository {
  late LocalStorage<UserEntity> _userLocalRepository;
  late LocalStorage<UserEntity> _sessionUserLocalRepository;

  AuthRepoImpl() {
    _userLocalRepository = CacheHelper.userLocalModel;
    _sessionUserLocalRepository = CacheHelper.sessionUserLocalModel;
  }
  UserEntity? get currentUser => _sessionUserLocalRepository.read(HiveKeys.sessionUser.name);

  List<UserEntity>? get userList => _userLocalRepository.list;
  @override
  Future<RepoResult> createUserWithEmailAndPassword(UserEntity user) async {
    try {
      final emailExists = await checkIfEmailExistsFromId(user.id);
      if (emailExists) {
        return RepoResult.error('Email already exists');
      } else {
        await _userLocalRepository.write(user.id, user);
        return RepoResult.success(null);
      }
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<RepoResult<UserEntity>> signInWithEmailAndPassword({required String email, required String password}) async {
    // check if users entity exists with same password
    final user = userList?.firstWhere(
      (user) => user.email == email,
      orElse: () => UserEntity(id: '', name: '', email: '', createdAt: '', password: ''),
    );
    if (user == null || user.email.isEmpty) {
      return RepoResult.error('User not found');
    } else if (user.password != password) {
      return RepoResult.error('Incorrect password');
    } else {
      setCurrentUser(user);
      return RepoResult.success(user);
    }
  }

  @override
  Future<RepoResult> signOut() async {
    try {
      if (currentUser?.email == null || currentUser?.id == null) {
        return RepoResult.error('No user is currently signed in.');
      } else {
        await _userLocalRepository.remove(currentUser!.id);
        await _sessionUserLocalRepository.remove(HiveKeys.sessionUser.name);
        return RepoResult.success(null);
      }
    } catch (e) {
      return RepoResult.error(e.toString());
    }
  }

  @override
  Future<void> setCurrentUser(UserEntity user) async {
    try {
      await _sessionUserLocalRepository.write(HiveKeys.sessionUser.name, user.copyWith());
    } catch (e) {
      // Handle error
      print('Error setting current user email: $e');
    }
  }

  @override
  Future<bool> checkIfEmailExistsFromId(String email) async {
    try {
      final users = userList;
      print('what is the userList: $users');
      final user = users?.firstWhere(
        (user) => user.email == email,
        orElse: () => UserEntity(id: '', name: '', email: '', createdAt: '', password: ''),
      );
      if (user == null || user.email.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
