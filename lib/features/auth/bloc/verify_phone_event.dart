import 'package:equatable/equatable.dart';

abstract class VerifyPhoneEvent extends Equatable {
  const VerifyPhoneEvent();

  @override
  List<Object?> get props => [];
}

class VerifyPhoneCodeChangedEvent extends VerifyPhoneEvent {
  const VerifyPhoneCodeChangedEvent(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class VerifyPhoneSubmittedEvent extends VerifyPhoneEvent {
  const VerifyPhoneSubmittedEvent();
}
