import 'package:equatable/equatable.dart';

import 'signup_result.dart';
import 'user_summary.dart';

class VerifyPhoneResult extends Equatable {
  const VerifyPhoneResult({
    required this.message,
    required this.user,
    required this.token,
  });

  final String message;
  final UserSummary user;
  final String token;

  SignupResult toSignupResult() => SignupResult(
        message: message,
        user: user,
      );

  @override
  List<Object?> get props => [message, user, token];
}
