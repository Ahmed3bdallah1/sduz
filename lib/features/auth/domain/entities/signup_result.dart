import 'package:equatable/equatable.dart';

import 'user_summary.dart';

class SignupResult extends Equatable {
  const SignupResult({
    required this.message,
    required this.user,
  });

  final String message;
  final UserSummary user;

  @override
  List<Object?> get props => [message, user];
}
