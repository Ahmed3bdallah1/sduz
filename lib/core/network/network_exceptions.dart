/// Base class for all network level exceptions thrown by the Dio client wrapper.
abstract class AppNetworkException implements Exception {
  const AppNetworkException({
    required this.message,
    this.statusCode,
    this.details,
  });

  final String message;
  final int? statusCode;
  final dynamic details;

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

class UnauthorizedException extends AppNetworkException {
  const UnauthorizedException({
    super.message = 'Unauthorized request',
    super.statusCode = 401,
    super.details,
  });
}

class ForbiddenException extends AppNetworkException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action',
    super.statusCode = 403,
    super.details,
  });
}

class NotFoundException extends AppNetworkException {
  const NotFoundException({
    super.message = 'Requested resource was not found',
    super.statusCode = 404,
    super.details,
  });
}

class ValidationException extends AppNetworkException {
  const ValidationException({
    required this.fieldErrors,
    super.message = 'Validation failed',
    super.statusCode = 422,
    super.details,
  });

  final Map<String, List<String>> fieldErrors;
}

class RateLimitException extends AppNetworkException {
  const RateLimitException({
    super.message = 'Too many requests, please try again later',
    super.statusCode = 429,
    super.details,
  });
}

class ServerException extends AppNetworkException {
  const ServerException({
    super.message = 'Server error, please try again later',
    super.statusCode,
    super.details,
  });
}

class NetworkTimeoutException extends AppNetworkException {
  const NetworkTimeoutException({
    super.message = 'Connection timed out',
    super.statusCode,
    super.details,
  });
}

class NoConnectionException extends AppNetworkException {
  const NoConnectionException({
    super.message = 'No internet connection detected',
    super.statusCode,
    super.details,
  });
}

class UnknownNetworkException extends AppNetworkException {
  const UnknownNetworkException({
    super.message = 'Unexpected error occurred',
    super.statusCode,
    super.details,
  });
}
