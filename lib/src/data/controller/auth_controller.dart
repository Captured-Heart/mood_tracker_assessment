// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/src/data/repository/auth_repo_impl.dart';
import 'package:mood_tracker_assessment/src/domain/entities/user_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/auth_repository.dart';
import 'package:mood_tracker_assessment/src/domain/repository/results_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:mood_tracker_assessment/utils/loader_util.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _loginFormKey;

  late AuthRepository _authRepository;

  @override
  build() {
    _authRepository = ref.read(authRepositoryProvider);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginFormKey = GlobalKey<FormState>();
    return AuthState();
  }

  // -------- GETTERS --------
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;

  // clear textfields after activity
  void _onSuccessFul({bool isSignOut = false, UserEntity? currentUser}) {
    _setIsLoading(false);
    if (!isSignOut) {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      state = state.copyWith(isAuthenticated: true, currentUser: currentUser);
      return;
    }
    state = state.copyWith(isSignOut: true, isAuthenticated: false);
  }

  // set loading state
  void _setIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  // set error message
  void _setErrorMessage(String? errorMessage) {
    _setIsLoading(false);
    state = state.copyWith(errorMessage: errorMessage);
  }

  // hide/show password
  void hideShowPassword() {
    state = state.copyWith(hidePassword: !state.hidePassword);
  }

  void toggleLoginState() {
    state = state.copyWith(isLogin: !state.isLogin);
  }

  void resetErrorMessage() {
    state = state.copyWith(errorMessage: '');
  }

  // -------------- CREATE ACCOUNT ------------------
  Future<void> createUserWithEmailAndPassword() async {
    _setIsLoading(true);
    final result = await simulateLoader(
      () => _authRepository.createUserWithEmailAndPassword(
        UserEntity(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          id: Uuid().v4(),
          createdAt: DateTime.now().toIso8601String(),
        ),
      ),
    );
    return switch (result) {
      RepoError(message: var message) => _setErrorMessage(message),
      RepoSuccess() => _onSuccessFul(),
    };
  }

  // ---------- SIGN IN ==================
  Future<void> signInWithEmailAndPassword() async {
    _setIsLoading(true);
    final result = await simulateLoader(
      () => _authRepository.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );

    return switch (result) {
      RepoError(message: var message) => _setErrorMessage(message),
      RepoSuccess(value: var user) => _onSuccessFul(currentUser: user),
    };
  }

  // ---------- SIGN OUT ==================
  Future<void> signOut() async {
    _setIsLoading(true);
    final result = await simulateLoader(() => _authRepository.signOut());

    return switch (result) {
      RepoError(message: var message) => _setErrorMessage(message),
      RepoSuccess() => _onSuccessFul(isSignOut: true),
    };
  }
}

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool hidePassword;
  final bool isLogin;
  final bool isAuthenticated;
  final bool isSignOut;
  final UserEntity? currentUser;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.hidePassword = true,
    this.isLogin = false,
    this.isAuthenticated = false,
    this.isSignOut = false,
    this.currentUser,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? hidePassword,
    bool? isLogin,
    bool? isAuthenticated,
    bool? isSignOut,
    UserEntity? currentUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hidePassword: hidePassword ?? this.hidePassword,
      isLogin: isLogin ?? this.isLogin,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSignOut: isSignOut ?? this.isSignOut,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
