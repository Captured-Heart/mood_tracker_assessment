import 'dart:async';

/// A utility function to simulate a loading delay for repository methods.
Future<T> simulateLoader<T>(FutureOr<T> Function() action, {int milliseconds = 3000}) async {
  return await Future.delayed(Duration(milliseconds: milliseconds), action);
}
