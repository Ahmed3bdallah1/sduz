import 'package:equatable/equatable.dart';

abstract class DedicationEvent extends Equatable {
  const DedicationEvent();

  @override
  List<Object?> get props => [];
}

class DedicationStarted extends DedicationEvent {
  const DedicationStarted();
}

class DedicationPhoneChanged extends DedicationEvent {
  final String phoneNumber;

  const DedicationPhoneChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class DedicationTypeSelected extends DedicationEvent {
  final String typeId;

  const DedicationTypeSelected(this.typeId);

  @override
  List<Object?> get props => [typeId];
}

class DedicationSubmitted extends DedicationEvent {
  const DedicationSubmitted();
}

class DedicationFeedbackCleared extends DedicationEvent {
  const DedicationFeedbackCleared();
}
