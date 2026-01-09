part of 'service_checkout_bloc.dart';

enum ServiceCheckoutStatus {
  initial,
  ready,
  processing,
  success,
  failure,
}

extension ServiceCheckoutStatusX on ServiceCheckoutStatus {
  bool get isInitial => this == ServiceCheckoutStatus.initial;
  bool get isReady => this == ServiceCheckoutStatus.ready;
  bool get isProcessing => this == ServiceCheckoutStatus.processing;
  bool get isSuccess => this == ServiceCheckoutStatus.success;
  bool get isFailure => this == ServiceCheckoutStatus.failure;
}

class ServiceCheckoutState extends Equatable {
  const ServiceCheckoutState({
    this.status = ServiceCheckoutStatus.initial,
    required this.serviceType,
    required this.car,
    required this.address,
    required this.scheduleSelection,
    this.activePackage,
    this.selectedPaymentMethod,
    this.notes,
    this.createdBooking,
    this.errorMessage,
  });

  final ServiceCheckoutStatus status;
  final ServiceType serviceType;
  final ServiceCar car;
  final UserAddress address;
  final ServiceScheduleSelection scheduleSelection;
  final ServicePackage? activePackage;
  final String? selectedPaymentMethod;
  final String? notes;
  final Booking? createdBooking;
  final String? errorMessage;

  bool get hasActivePackage {
    final package = activePackage;
    if (package == null) return false;
    return package.isEnabled && package.remainingWashes > 0;
  }

  double get totalAmount {
    // If using package, amount is 0 (covered by package)
    if (hasActivePackage) {
      return 0.0;
    }
    return serviceType.price.toDouble();
  }

  bool get canSubmit {
    return selectedPaymentMethod != null && !status.isProcessing;
  }

  ServiceCheckoutState copyWith({
    ServiceCheckoutStatus? status,
    ServiceType? serviceType,
    ServiceCar? car,
    UserAddress? address,
    ServiceScheduleSelection? scheduleSelection,
    ServicePackage? activePackage,
    String? selectedPaymentMethod,
    bool overrideSelectedPaymentMethod = false,
    String? notes,
    Booking? createdBooking,
    bool overrideCreatedBooking = false,
    String? errorMessage,
    bool overrideErrorMessage = false,
  }) {
    return ServiceCheckoutState(
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      car: car ?? this.car,
      address: address ?? this.address,
      scheduleSelection: scheduleSelection ?? this.scheduleSelection,
      activePackage: activePackage ?? this.activePackage,
      selectedPaymentMethod: overrideSelectedPaymentMethod
          ? selectedPaymentMethod
          : (selectedPaymentMethod ?? this.selectedPaymentMethod),
      notes: notes ?? this.notes,
      createdBooking: overrideCreatedBooking
          ? createdBooking
          : (createdBooking ?? this.createdBooking),
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
        address,
        scheduleSelection,
        activePackage,
        selectedPaymentMethod,
        notes,
        createdBooking,
        errorMessage,
      ];
}

