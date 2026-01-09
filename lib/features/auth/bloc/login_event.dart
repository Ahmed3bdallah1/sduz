import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitEvent extends LoginEvent {
  final String emailOrPhone;
  final String password;

  const LoginSubmitEvent({required this.emailOrPhone, required this.password});

  @override
  List<Object?> get props => [emailOrPhone, password];
}

class LoginEmailChangedEvent extends LoginEvent {
  final String emailOrPhone;

  const LoginEmailChangedEvent(this.emailOrPhone);

  @override
  List<Object?> get props => [emailOrPhone];
}

class LoginPasswordChangedEvent extends LoginEvent {
  final String password;

  const LoginPasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginTogglePasswordVisibilityEvent extends LoginEvent {
  const LoginTogglePasswordVisibilityEvent();
}
