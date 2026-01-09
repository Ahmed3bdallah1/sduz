import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupSubmitEvent extends SignupEvent {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;

  const SignupSubmitEvent({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phoneNumber, email, password];
}

class SignupNameChangedEvent extends SignupEvent {
  final String name;

  const SignupNameChangedEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class SignupPhoneNumberChangedEvent extends SignupEvent {
  final String phoneNumber;

  const SignupPhoneNumberChangedEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SignupEmailChangedEvent extends SignupEvent {
  final String email;

  const SignupEmailChangedEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChangedEvent extends SignupEvent {
  final String password;

  const SignupPasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupTogglePasswordVisibilityEvent extends SignupEvent {
  const SignupTogglePasswordVisibilityEvent();
}
