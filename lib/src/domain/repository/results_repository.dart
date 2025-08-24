sealed class RepoResult<T> {
  const RepoResult();
  factory RepoResult.success(T value) = RepoSuccess<T>;
  factory RepoResult.error(String message) = RepoError<T>;
}

class RepoSuccess<T> extends RepoResult<T> {
  final T value;
  const RepoSuccess(this.value);
}

class RepoError<T> extends RepoResult<T> {
  final String message;
  const RepoError(this.message);
}
