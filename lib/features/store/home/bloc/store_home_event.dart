import 'package:equatable/equatable.dart';

abstract class StoreHomeEvent extends Equatable {
  const StoreHomeEvent();

  @override
  List<Object?> get props => [];
}

class StoreHomeStarted extends StoreHomeEvent {
  const StoreHomeStarted();
}
