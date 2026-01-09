import 'package:equatable/equatable.dart';

import 'package:sudz/features/car/models/service_car.dart';
import 'package:sudz/features/service/checkout_selection/models/models.dart';
import 'package:sudz/features/service/models/models.dart';
import 'package:sudz/features/service/schedule/models/models.dart';

enum ServiceCheckoutSelectionStatus { initial, loading, ready, failure }

extension ServiceCheckoutSelectionStatusX on ServiceCheckoutSelectionStatus {
  bool get isInitial => this == ServiceCheckoutSelectionStatus.initial;
  bool get isLoading => this == ServiceCheckoutSelectionStatus.loading;
  bool get isReady => this == ServiceCheckoutSelectionStatus.ready;
  bool get isFailure => this == ServiceCheckoutSelectionStatus.failure;
}

class ServiceCheckoutSelectionState extends Equatable {
  final ServiceCheckoutSelectionStatus status;
  final ServiceType serviceType;
  final ServiceCar? car;
  final ServicePackage? package;
  final ServiceScheduleSelection? schedule;
  final ServiceCheckoutOption? selectedOption;
  final bool showValidationError;
  final ServiceCheckoutNextStep? nextStep;
  final String? errorMessage;

  const ServiceCheckoutSelectionState({
    required this.serviceType,
    this.status = ServiceCheckoutSelectionStatus.initial,
    this.car,
    this.package,
    this.schedule,
    this.selectedOption,
    this.showValidationError = false,
    this.nextStep,
    this.errorMessage,
  });

  bool get hasAvailablePackage {
    final currentPackage = package;
    if (currentPackage == null) {
      return false;
    }
    return currentPackage.isEnabled && currentPackage.remainingWashes > 0;
  }

  bool get canSubmit {
    if (selectedOption == null) {
      return false;
    }
    if (selectedOption == ServiceCheckoutOption.package) {
      return hasAvailablePackage;
    }
    return true;
  }

  ServiceCheckoutSelectionState copyWith({
    ServiceCheckoutSelectionStatus? status,
    ServiceType? serviceType,
    ServiceCar? car,
    bool overrideCar = false,
    ServicePackage? package,
    bool overridePackage = false,
    ServiceScheduleSelection? schedule,
    bool overrideSchedule = false,
    ServiceCheckoutOption? selectedOption,
    bool overrideSelectedOption = false,
    bool? showValidationError,
    ServiceCheckoutNextStep? nextStep,
    bool overrideNextStep = false,
    String? errorMessage,
    bool overrideErrorMessage = false,
  }) {
    return ServiceCheckoutSelectionState(
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      car: overrideCar ? car : (car ?? this.car),
      package: overridePackage ? package : (package ?? this.package),
      schedule: overrideSchedule ? schedule : (schedule ?? this.schedule),
      selectedOption: overrideSelectedOption
          ? selectedOption
          : (selectedOption ?? this.selectedOption),
      showValidationError: showValidationError ?? this.showValidationError,
      nextStep: overrideNextStep ? nextStep : (nextStep ?? this.nextStep),
      errorMessage: overrideErrorMessage
          ? errorMessage
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    serviceType,
    car,
    package,
    schedule,
    selectedOption,
    showValidationError,
    nextStep,
    errorMessage,
  ];
}
