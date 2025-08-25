import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_assessment/src/domain/entities/book_demo_entity.dart';
import 'package:mood_tracker_assessment/src/domain/repository/network/network_calls_repository.dart';
import 'package:mood_tracker_assessment/src/data/repository/network/network_calls_repo_impl.dart';

final bookDemoControllerProvider = NotifierProvider<BookDemoController, BookDemoState>(() {
  return BookDemoController();
});

class BookDemoController extends Notifier<BookDemoState> {
  late NetworkCallsRepository _networkRepository;
  @override
  BookDemoState build() {
    _networkRepository = ref.read(networkCallsRepositoryProvider);
    return const BookDemoState();
  }

  /// Perform a GET request
  Future<void> getBooks({Options? options, String query = 'flutter', CancelToken? cancelToken}) async {
    _clearError();
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _networkRepository.get(
        'https://openlibrary.org/search.json',
        queryParameters: {'q': query, 'limit': 10, 'fields': 'key,title,author_name,first_publish_year,isbn,cover_i'},
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: (int received, int total) {
          // Optionally handle progress
          print(' Received progress: received: $received of total: $total');
        },
      );

      final data = response.data;
      final List<dynamic> docs = data['docs'] ?? [];
      final List<BookDemoEntity> bookLists = docs.map((book) => BookDemoEntity.fromMap(book)).toList();
      print('this is the book lists: ${bookLists.map((book) => book).toString()}');
      state = state.copyWith(
        isLoading: false,
        error: response.hasError ? response.errorMessage : null,
        isConnected: !response.isNetworkError,
        bookLists: bookLists,
      );
    } catch (e) {
      print('what is the error: $e');
      state = state.copyWith(isLoading: false, error: e.toString(), isConnected: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Clear error state
  void _clearError() {
    state = state.copyWith(error: null);
  }

  void resetBooksList() {
    state = state.copyWith(bookLists: []);
  }

  /// Set loading state manually
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Update connection status
  void updateConnectionStatus(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }
}

class BookDemoState {
  final bool isLoading;
  final String? error;
  final bool isConnected;
  final List<BookDemoEntity> bookLists;

  const BookDemoState({this.isLoading = false, this.error, this.isConnected = true, this.bookLists = const []});

  BookDemoState copyWith({bool? isLoading, String? error, bool? isConnected, List<BookDemoEntity>? bookLists}) {
    return BookDemoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isConnected: isConnected ?? this.isConnected,
      bookLists: bookLists ?? this.bookLists,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookDemoState &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isConnected == isConnected &&
        other.bookLists == bookLists;
  }

  @override
  int get hashCode => isLoading.hashCode ^ error.hashCode ^ isConnected.hashCode ^ bookLists.hashCode;

  @override
  String toString() =>
      'BookDemoState(isLoading: $isLoading, error: $error, isConnected: $isConnected, bookLists: $bookLists)';
}
