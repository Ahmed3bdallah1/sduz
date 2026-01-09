import 'package:equatable/equatable.dart';

abstract class MyCarsEvent extends Equatable {
  const MyCarsEvent();

  @override
  List<Object?> get props => [];
}

class MyCarsStarted extends MyCarsEvent {
  const MyCarsStarted({this.showLoader = true});

  final bool showLoader;

  @override
  List<Object?> get props => [showLoader];
}

class MyCarSelected extends MyCarsEvent {
  final String carId;

  const MyCarSelected(this.carId);

  @override
  List<Object?> get props => [carId];
}

class MyCarDeleted extends MyCarsEvent {
  final String carId;

  const MyCarDeleted(this.carId);

  @override
  List<Object?> get props => [carId];
}

class MyCarSetPrimary extends MyCarsEvent {
  final String carId;

  const MyCarSetPrimary(this.carId);

  @override
  List<Object?> get props => [carId];
}
