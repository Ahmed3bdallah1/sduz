part of 'service_checkout_bloc.dart';

abstract class ServiceCheckoutEvent extends Equatable {
  const ServiceCheckoutEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCheckoutStarted extends ServiceCheckoutEvent {
  const ServiceCheckoutStarted();
}

class ServiceCheckoutPaymentMethodChanged extends ServiceCheckoutEvent {
  const ServiceCheckoutPaymentMethodChanged(this.paymentMethod);

  final String paymentMethod;

  @override
  List<Object?> get props => [paymentMethod];
}

class ServiceCheckoutNotesChanged extends ServiceCheckoutEvent {
  const ServiceCheckoutNotesChanged(this.notes);

  final String notes;

  @override
  List<Object?> get props => [notes];
}

class ServiceCheckoutSubmitted extends ServiceCheckoutEvent {
  const ServiceCheckoutSubmitted();
}

