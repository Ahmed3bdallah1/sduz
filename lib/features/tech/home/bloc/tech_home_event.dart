import 'package:equatable/equatable.dart';

abstract class TechHomeEvent extends Equatable {
  const TechHomeEvent();

  @override
  List<Object?> get props => [];
}

class TechHomeStarted extends TechHomeEvent {
  const TechHomeStarted();
}

class TechHomeBottomNavChanged extends TechHomeEvent {
  final int index;

  const TechHomeBottomNavChanged(this.index);

  @override
  List<Object?> get props => [index];
}
