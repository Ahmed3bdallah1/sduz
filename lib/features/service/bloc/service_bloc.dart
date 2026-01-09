import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/car/domain/repositories/car_repository.dart';
import 'package:sudz/features/car/models/models.dart';
import 'package:sudz/features/packages/domain/entities/user_package.dart';
import 'package:sudz/features/packages/domain/repositories/packages_repository.dart';
import '../domain/repositories/service_repository.dart';
import '../models/models.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc({
    required CarRepository carRepository,
    required ServiceRepository serviceRepository,
    PackagesRepository? packagesRepository,
  })  : _carRepository = carRepository,
        _serviceRepository = serviceRepository,
        _packagesRepository = packagesRepository,
        super(const ServiceState()) {
    on<ServiceStarted>(_onStarted);
    on<ServicePackageToggled>(_onPackageToggled);
    on<ServiceCarSelected>(_onCarSelected);
    on<ServiceCarAdded>(_onCarAdded);
    on<ServiceTypeSelected>(_onServiceSelected);
    on<ServiceTypeExpansionToggled>(_onExpansionToggled);
  }

  final CarRepository _carRepository;
  final ServiceRepository _serviceRepository;
  final PackagesRepository? _packagesRepository;

  Future<void> _onStarted(
    ServiceStarted event,
    Emitter<ServiceState> emit,
  ) async {
    emit(state.copyWith(status: ServiceStatus.loading, errorMessage: null));

    try {
      // Fetch user's cars
      final userCars = await _carRepository.fetchCars();
      final cars = userCars.map(ServiceCar.fromUserCar).toList(growable: false);

      // Fetch services from API
      final services = await _serviceRepository.fetchServices();
      final serviceTypes = services
          .map((service) => ServiceType.fromService(service))
          .toList(growable: false);

      final activePackage = await _fetchActivePackage();

      emit(
        state.copyWith(
          status: ServiceStatus.success,
          activePackage: activePackage,
          overrideActivePackage: true,
          cars: cars,
          selectedCarId: cars.isNotEmpty ? cars.first.id : null,
          overrideSelectedCar: true,
          serviceTypes: serviceTypes,
          selectedServiceTypeId: _resolveInitialServiceType(
            serviceTypes,
            event.initialServiceTypeId,
          ),
          overrideSelectedServiceType: true,
          expandedServiceTypeIds: const {},
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ServiceStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  String? _resolveInitialServiceType(
    List<ServiceType> serviceTypes,
    String? requestedId,
  ) {
    if (serviceTypes.isEmpty) return null;
    if (requestedId != null) {
      final match = serviceTypes.firstWhere(
        (type) => type.id == requestedId,
        orElse: () => serviceTypes.first,
      );
      return match.id;
    }
    return serviceTypes.first.id;
  }

  void _onPackageToggled(
    ServicePackageToggled event,
    Emitter<ServiceState> emit,
  ) {
    emit(state.togglePackageEnabled());
  }

  void _onCarSelected(ServiceCarSelected event, Emitter<ServiceState> emit) {
    if (state.cars.isEmpty) {
      emit(state.copyWith(selectedCarId: null, overrideSelectedCar: true));
      return;
    }

    final car = state.cars.firstWhere(
      (item) => item.id == event.carId,
      orElse: () => state.cars.first,
    );

    emit(state.selectCar(car));
  }

  void _onCarAdded(ServiceCarAdded event, Emitter<ServiceState> emit) {
    final updatedCars = List<ServiceCar>.from(state.cars)..add(event.car);

    emit(
      state.copyWith(
        cars: updatedCars,
        selectedCarId: event.car.id,
        overrideSelectedCar: true,
      ),
    );
  }

  void _onServiceSelected(
    ServiceTypeSelected event,
    Emitter<ServiceState> emit,
  ) {
    emit(
      state.copyWith(
        selectedServiceTypeId: event.serviceTypeId,
        overrideSelectedServiceType: true,
      ),
    );
  }

  void _onExpansionToggled(
    ServiceTypeExpansionToggled event,
    Emitter<ServiceState> emit,
  ) {
    emit(state.toggleExpansion(event.serviceTypeId));
  }

  Future<ServicePackage?> _fetchActivePackage() async {
    if (_packagesRepository == null) return null;
    try {
      final userPackages = await _packagesRepository!.fetchMyActivePackages();
      final active = _pickActive(userPackages);
      if (active == null) return null;
      final remainingDays = active.expiryDate.difference(DateTime.now()).inDays;
      return ServicePackage(
        id: active.id,
        name: active.packageTitle,
        remainingDays: remainingDays.clamp(0, 999),
        remainingWashes: active.washesRemaining,
        isEnabled: true,
      );
    } catch (_) {
      return null;
    }
  }

  UserPackage? _pickActive(List<UserPackage> packages) {
    for (final pkg in packages) {
      if (pkg.isActive) return pkg;
    }
    return packages.isNotEmpty ? packages.first : null;
  }
}
