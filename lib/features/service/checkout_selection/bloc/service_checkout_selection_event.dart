import 'package:equatable/equatable.dart';

import 'package:sudz/features/service/checkout_selection/models/models.dart';

abstract class ServiceCheckoutSelectionEvent extends Equatable {
  const ServiceCheckoutSelectionEvent();

  @override
  List<Object?> get props => [];
}

class ServiceCheckoutSelectionStarted extends ServiceCheckoutSelectionEvent {
  const ServiceCheckoutSelectionStarted();
}

class ServiceCheckoutOptionChanged extends ServiceCheckoutSelectionEvent {
  final ServiceCheckoutOption option;

  const ServiceCheckoutOptionChanged(this.option);

  @override
  List<Object?> get props => [option];
}

class ServiceCheckoutContinuePressed extends ServiceCheckoutSelectionEvent {
  const ServiceCheckoutContinuePressed();
}

class ServiceCheckoutNavigationHandled extends ServiceCheckoutSelectionEvent {
  const ServiceCheckoutNavigationHandled();
}
