import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/domain/repositories/repository_interfaces.dart';

/// Custom matchers for Result type
class ResultMatchers {
  /// Matches a successful Result
  static Matcher isSuccess() => _IsSuccessMatcher();

  /// Matches a successful Result with specific data
  static Matcher isSuccessWith<T>(T data) => _IsSuccessWithMatcher<T>(data);

  /// Matches a failed Result
  static Matcher isFailure() => _IsFailureMatcher();

  /// Matches a failed Result with specific error message
  static Matcher isFailureWith(String errorMessage) =>
      _IsFailureWithMatcher(errorMessage);

  /// Matches a failed Result containing error message substring
  static Matcher isFailureContaining(String substring) =>
      _IsFailureContainingMatcher(substring);
}

class _IsSuccessMatcher extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('is a successful Result');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Result) return false;
    return item is Success;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Result) {
      return mismatchDescription.add('is not a Result');
    }
    if (item is Failure) {
      return mismatchDescription.add('is failure with: ${item.message}');
    }
    return mismatchDescription.add('unexpected result type');
  }
}

class _IsSuccessWithMatcher<T> extends Matcher {
  final T expectedData;

  _IsSuccessWithMatcher(this.expectedData);

  @override
  Description describe(Description description) =>
      description.add('is a successful Result with data: $expectedData');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Result<T>) return false;
    if (item is Success<T>) {
      return item.data == expectedData;
    }
    return false;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Result) {
      return mismatchDescription.add('is not a Result');
    }
    if (item is Success<T>) {
      return mismatchDescription.add('has different data: ${item.data}');
    }
    if (item is Failure) {
      return mismatchDescription.add('is failure with: ${item.message}');
    }
    return mismatchDescription.add('unexpected result type');
  }
}

class _IsFailureMatcher extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('is a failed Result');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Result) return false;
    return item is Failure;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Result) {
      return mismatchDescription.add('is not a Result');
    }
    if (item is Success) {
      return mismatchDescription.add('is success with: ${item.data}');
    }
    return mismatchDescription.add('unexpected result type');
  }
}

class _IsFailureWithMatcher extends Matcher {
  final String expectedError;

  _IsFailureWithMatcher(this.expectedError);

  @override
  Description describe(Description description) =>
      description.add('is a failed Result with error: $expectedError');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Result) return false;
    if (item is Failure) {
      return item.message == expectedError;
    }
    return false;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Result) {
      return mismatchDescription.add('is not a Result');
    }
    if (item is Success) {
      return mismatchDescription.add('is success with: ${item.data}');
    }
    if (item is Failure) {
      return mismatchDescription.add('has different error: ${item.message}');
    }
    return mismatchDescription.add('unexpected result type');
  }
}

class _IsFailureContainingMatcher extends Matcher {
  final String substring;

  _IsFailureContainingMatcher(this.substring);

  @override
  Description describe(Description description) =>
      description.add('is a failed Result containing: $substring');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Result) return false;
    if (item is Failure) {
      return item.message.contains(substring);
    }
    return false;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Result) {
      return mismatchDescription.add('is not a Result');
    }
    if (item is Success) {
      return mismatchDescription.add('is success with: ${item.data}');
    }
    if (item is Failure) {
      return mismatchDescription.add(
        'error does not contain substring: ${item.message}',
      );
    }
    return mismatchDescription.add('unexpected result type');
  }
}
