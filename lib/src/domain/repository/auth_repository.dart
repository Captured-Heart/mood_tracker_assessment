import 'package:mood_tracker_assessment/src/domain/entities/user_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';

abstract class AuthRepository {
  Future<RepoResult> signInWithEmailAndPassword({required String email, required String password});

  Future<RepoResult> createUserWithEmailAndPassword(UserEntity user);

  Future<RepoResult> signOut();

  Future<void> setCurrentUser(UserEntity user);

  Future<bool> checkIfEmailExistsFromId(String id);
}
