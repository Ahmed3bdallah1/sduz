import 'package:equatable/equatable.dart';

import '../../../car/models/service_car.dart';
import '../../schedule/models/models.dart';
import '../../models/models.dart';

enum ServiceCheckoutOption { singleService, package }

enum ServiceCheckoutNextStep { singleService, package }

class ServiceCheckoutSelectionParams extends Equatable {
  final ServiceType serviceType;
  final ServiceCar? car;
  final ServicePackage? activePackage;
  final ServiceScheduleSelection? scheduleSelection;

  const ServiceCheckoutSelectionParams({
    required this.serviceType,
    this.car,
    this.activePackage,
    this.scheduleSelection,
  });

  bool get hasAvailablePackage {
    final package = activePackage;
    if (package == null) {
      return false;
    }
    return package.isEnabled && package.remainingWashes > 0;
  }

  @override
  List<Object?> get props => [
    serviceType,
    car,
    activePackage,
    scheduleSelection,
  ];
}
