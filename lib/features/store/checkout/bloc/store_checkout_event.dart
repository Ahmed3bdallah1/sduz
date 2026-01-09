import 'package:equatable/equatable.dart';

abstract class StoreCheckoutEvent extends Equatable {
  const StoreCheckoutEvent();

  @override
  List<Object?> get props => [];
}

class StoreCheckoutStarted extends StoreCheckoutEvent {
  final double total;

  const StoreCheckoutStarted({required this.total});

  @override
  List<Object?> get props => [total];
}

class StoreCheckoutPaymentSelected extends StoreCheckoutEvent {
  final String methodId;

  const StoreCheckoutPaymentSelected(this.methodId);

  @override
  List<Object?> get props => [methodId];
}
