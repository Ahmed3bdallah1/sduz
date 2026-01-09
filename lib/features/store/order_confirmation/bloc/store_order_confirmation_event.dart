import 'package:equatable/equatable.dart';

abstract class StoreOrderConfirmationEvent extends Equatable {
  const StoreOrderConfirmationEvent();

  @override
  List<Object?> get props => [];
}

class StoreOrderConfirmationStarted extends StoreOrderConfirmationEvent {
  const StoreOrderConfirmationStarted();
}
