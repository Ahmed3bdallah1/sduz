import 'package:equatable/equatable.dart';

abstract class ProfileHomeEvent extends Equatable {
  const ProfileHomeEvent();

  @override
  List<Object?> get props => [];
}

class ProfileHomeStarted extends ProfileHomeEvent {
  const ProfileHomeStarted();
}

class ProfileLanguageToggled extends ProfileHomeEvent {
  final String code;

  const ProfileLanguageToggled(this.code);

  @override
  List<Object?> get props => [code];
}
