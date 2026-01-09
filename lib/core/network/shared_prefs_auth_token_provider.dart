import 'dart:async';

import '../local_database/local_database_service.dart';
import 'auth_token_provider.dart';

class SharedPrefsAuthTokenProvider implements AuthTokenProvider {
  SharedPrefsAuthTokenProvider(this._localDatabase);

  final LocalDatabaseService _localDatabase;

  @override
  bool get canRefresh => false;

  @override
  FutureOr<String?> readAccessToken() {
    return _localDatabase.getToken();
  }

  @override
  Future<String?> refreshAccessToken() async => null;

  @override
  FutureOr<void> saveAccessToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _localDatabase.clearToken();
    } else {
      await _localDatabase.saveToken(token);
    }
  }
}
