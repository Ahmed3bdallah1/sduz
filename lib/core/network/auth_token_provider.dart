import 'dart:async';

/// Defines how access tokens are read, written, and refreshed.
abstract class AuthTokenProvider {
  /// Returns the current cached access token if available.
  FutureOr<String?> readAccessToken();

  /// Persists a newly issued access token.
  FutureOr<void> saveAccessToken(String? token);

  /// Refreshes the access token and returns the new token if refresh is successful.
  ///
  /// Implementations should throw if the refresh flow fails so the caller can react accordingly.
  Future<String?> refreshAccessToken();

  /// Whether the provider supports refreshing tokens. Defaults to `true`.
  bool get canRefresh => true;
}

/// No-op implementation used when authentication is not required yet.
class NullAuthTokenProvider implements AuthTokenProvider {
  const NullAuthTokenProvider();

  @override
  bool get canRefresh => false;

  @override
  FutureOr<String?> readAccessToken() => null;

  @override
  Future<String?> refreshAccessToken() async => null;

  @override
  FutureOr<void> saveAccessToken(String? token) {}
}
