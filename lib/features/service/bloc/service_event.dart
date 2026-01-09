import 'package:equatable/equatable.dart';
import 'package:sudz/features/car/models/models.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class ServiceStarted extends ServiceEvent {
  const ServiceStarted({this.initialServiceTypeId});

  final String? initialServiceTypeId;

  @override
  List<Object?> get props => [initialServiceTypeId];
}

class ServicePackageToggled extends ServiceEvent {
  const ServicePackageToggled();
}

class ServiceCarSelected extends ServiceEvent {
  final String carId;

  const ServiceCarSelected(this.carId);

  @override
  List<Object?> get props => [carId];
}

class ServiceTypeSelected extends ServiceEvent {
  final String serviceTypeId;

  const ServiceTypeSelected(this.serviceTypeId);

  @override
  List<Object?> get props => [serviceTypeId];
}

class ServiceTypeExpansionToggled extends ServiceEvent {
  final String serviceTypeId;

  const ServiceTypeExpansionToggled(this.serviceTypeId);

  @override
  List<Object?> get props => [serviceTypeId];
}

class ServiceCarAdded extends ServiceEvent {
  final ServiceCar car;

  const ServiceCarAdded(this.car);

  @override
  List<Object?> get props => [car];
}
