import 'package:kickbasekumpel/domain/repositories/repository_interfaces.dart';

/// Extension to add `when` method to Result for easier pattern matching in tests
extension ResultTestExtension<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.data);
    } else if (self is Failure<T>) {
      return failure(self.message);
    }
    throw StateError('Unknown Result type');
  }
}
