/// Exception classes for Kickbase API errors
///
/// Uses sealed class pattern for exhaustive error handling similar to AuthResult<T>
library;

/// Base class for all Kickbase API exceptions
class KickbaseException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const KickbaseException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    if (code != null) {
      return 'KickbaseException [$code]: $message';
    }
    return 'KickbaseException: $message';
  }
}

/// Authentication failed (401) or token is missing/invalid
class AuthenticationException extends KickbaseException {
  const AuthenticationException(
    super.message, {
    super.code = '401',
    super.originalError,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Resource not found (404)
class NotFoundException extends KickbaseException {
  final String? resourceId;

  const NotFoundException(
    super.message, {
    this.resourceId,
    super.code = '404',
    super.originalError,
  });

  @override
  String toString() {
    if (resourceId != null) {
      return 'NotFoundException: $message (Resource: $resourceId)';
    }
    return 'NotFoundException: $message';
  }
}

/// Rate limit exceeded (429)
class RateLimitException extends KickbaseException {
  final int? retryAfterSeconds;

  const RateLimitException(
    super.message, {
    this.retryAfterSeconds,
    super.code = '429',
    super.originalError,
  });

  @override
  String toString() {
    if (retryAfterSeconds != null) {
      return 'RateLimitException: $message (Retry after ${retryAfterSeconds}s)';
    }
    return 'RateLimitException: $message';
  }
}

/// Network connectivity issues
class NetworkException extends KickbaseException {
  const NetworkException(
    super.message, {
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Server error (5xx)
class ServerException extends KickbaseException {
  final int statusCode;

  const ServerException(
    super.message, {
    required this.statusCode,
    super.originalError,
  }) : super(code: 'SERVER_ERROR_$statusCode');

  @override
  String toString() => 'ServerException [$statusCode]: $message';
}

/// Request timeout
class TimeoutException extends KickbaseException {
  const TimeoutException(
    super.message, {
    super.code = 'TIMEOUT',
    super.originalError,
  });

  @override
  String toString() => 'TimeoutException: $message';
}

/// JSON parsing failed
class ParsingException extends KickbaseException {
  const ParsingException(
    super.message, {
    super.code = 'PARSING_ERROR',
    super.originalError,
  });

  @override
  String toString() => 'ParsingException: $message';
}

/// All endpoints failed (from tryMultipleEndpoints)
class AllEndpointsFailedException extends KickbaseException {
  final List<String> attemptedEndpoints;

  const AllEndpointsFailedException(
    super.message, {
    required this.attemptedEndpoints,
    super.code = 'ALL_ENDPOINTS_FAILED',
    super.originalError,
  });

  @override
  String toString() =>
      'AllEndpointsFailedException: $message (Tried: ${attemptedEndpoints.join(', ')})';
}
