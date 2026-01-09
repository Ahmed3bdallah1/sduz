import 'package:equatable/equatable.dart';
import 'package:sudz/features/car/models/models.dart';
import '../models/models.dart';

enum ServiceStatus { initial, loading, success, failure }

extension ServiceStatusX on ServiceStatus {
  bool get isInitial => this == ServiceStatus.initial;
  bool get isLoading => this == ServiceStatus.loading;
  bool get isSuccess => this == ServiceStatus.success;
  bool get isFailure => this == ServiceStatus.failure;
}

class ServiceState extends Equatable {
  final ServiceStatus status;
  final ServicePackage? activePackage;
  final List<ServiceCar> cars;
  final String? selectedCarId;
  final List<ServiceType> serviceTypes;
  final String? selectedServiceTypeId;
  final Set<String> expandedServiceTypeIds;
  final String? errorMessage;

  const ServiceState({
    this.status = ServiceStatus.initial,
    this.activePackage,
    this.cars = const [],
    this.selectedCarId,
    this.serviceTypes = const [],
    this.selectedServiceTypeId,
    this.expandedServiceTypeIds = const {},
    this.errorMessage,
  });

  ServiceState copyWith({
    ServiceStatus? status,
    ServicePackage? activePackage,
    bool overrideActivePackage = false,
    List<ServiceCar>? cars,
    String? selectedCarId,
    bool overrideSelectedCar = false,
    List<ServiceType>? serviceTypes,
    String? selectedServiceTypeId,
    bool overrideSelectedServiceType = false,
    Set<String>? expandedServiceTypeIds,
    String? errorMessage,
  }) {
    return ServiceState(
      status: status ?? this.status,
      activePackage: overrideActivePackage
          ? activePackage
          : (activePackage ?? this.activePackage),
      cars: cars ?? this.cars,
      selectedCarId: overrideSelectedCar
          ? selectedCarId
          : (selectedCarId ?? this.selectedCarId),
      serviceTypes: serviceTypes ?? this.serviceTypes,
      selectedServiceTypeId: overrideSelectedServiceType
          ? selectedServiceTypeId
          : (selectedServiceTypeId ?? this.selectedServiceTypeId),
      expandedServiceTypeIds:
          expandedServiceTypeIds ?? this.expandedServiceTypeIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activePackage,
        cars,
        selectedCarId,
        serviceTypes,
        selectedServiceTypeId,
        expandedServiceTypeIds,
        errorMessage,
      ];
}

extension ServiceStateX on ServiceState {
  bool get hasPackage => activePackage != null;
  bool get hasCars => cars.isNotEmpty;
  bool get hasServices => serviceTypes.isNotEmpty;

  ServiceCar? get selectedCar {
    if (selectedCarId == null) {
      return null;
    }
    for (final car in cars) {
      if (car.id == selectedCarId) {
        return car;
      }
    }
    return null;
  }

  ServiceType? get selectedServiceType {
    if (selectedServiceTypeId == null) {
      return null;
    }
    for (final type in serviceTypes) {
      if (type.id == selectedServiceTypeId) {
        return type;
      }
    }
    return null;
  }

  bool isExpanded(String serviceTypeId) =>
      expandedServiceTypeIds.contains(serviceTypeId);

  ServiceState toggleExpansion(String serviceTypeId) {
    final newExpanded = Set<String>.from(expandedServiceTypeIds);
    if (newExpanded.contains(serviceTypeId)) {
      newExpanded.remove(serviceTypeId);
    } else {
      newExpanded.add(serviceTypeId);
    }

    return copyWith(expandedServiceTypeIds: newExpanded);
  }

  ServiceState selectCar(ServiceCar car) => copyWith(
        selectedCarId: car.id,
        overrideSelectedCar: true,
      );

  ServiceState selectService(ServiceType serviceType) => copyWith(
        selectedServiceTypeId: serviceType.id,
        overrideSelectedServiceType: true,
      );

  ServiceState togglePackageEnabled() {
    if (activePackage == null) return this;
    return copyWith(
      activePackage: activePackage!.copyWith(
        isEnabled: !activePackage!.isEnabled,
      ),
      overrideActivePackage: true,
    );
  }
}
