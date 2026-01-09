import 'package:equatable/equatable.dart';
import 'package:sudz/features/car/domain/entities/car_size.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';

enum AddCarStatus { initial, loading, saving, success, failure }

extension AddCarStatusX on AddCarStatus {
  bool get isInitial => this == AddCarStatus.initial;
  bool get isLoading => this == AddCarStatus.loading;
  bool get isSaving => this == AddCarStatus.saving;
  bool get isSuccess => this == AddCarStatus.success;
  bool get isFailure => this == AddCarStatus.failure;
}

class AddCarState extends Equatable {
  const AddCarState({
    this.status = AddCarStatus.initial,
    this.name = '',
    this.brand = '',
    this.model = '',
    this.color = '',
    this.plateNumber = '',
    this.year,
    this.carSizes = const [],
    this.selectedCarSizeId,
    this.isPrimary = false,
    this.imagePath,
    this.errorMessage,
    this.createdCar,
    this.carId,
  });

  final AddCarStatus status;
  final String name;
  final String brand;
  final String model;
  final String color;
  final String plateNumber;
  final int? year;
  final List<CarSize> carSizes;
  final int? selectedCarSizeId;
  final bool isPrimary;
  final String? imagePath;
  final String? errorMessage;
  final UserCar? createdCar;
  final String? carId;

  bool get isEditing => carId != null;

  bool get hasBrand => brand.trim().isNotEmpty;
  bool get hasModel => model.trim().isNotEmpty;
  bool get hasColor => color.trim().isNotEmpty;
  bool get hasPlate => plateNumber.trim().isNotEmpty;
  bool get hasSize => selectedCarSizeId != null;

  bool get isFormValid =>
      hasBrand && hasModel && hasColor && hasPlate && hasSize;

  AddCarState copyWith({
    AddCarStatus? status,
    String? name,
    String? brand,
    String? model,
    String? color,
    String? plateNumber,
    int? year,
    bool clearYear = false,
    List<CarSize>? carSizes,
    int? selectedCarSizeId,
    bool clearSelectedSize = false,
    bool? isPrimary,
    String? imagePath,
    String? errorMessage,
    bool clearError = false,
    UserCar? createdCar,
    bool clearCreatedCar = false,
    String? carId,
  }) {
    return AddCarState(
      status: status ?? this.status,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      color: color ?? this.color,
      plateNumber: plateNumber ?? this.plateNumber,
      year: clearYear ? null : (year ?? this.year),
      carSizes: carSizes ?? this.carSizes,
      selectedCarSizeId: clearSelectedSize
          ? null
          : (selectedCarSizeId ?? this.selectedCarSizeId),
      isPrimary: isPrimary ?? this.isPrimary,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdCar: clearCreatedCar ? null : (createdCar ?? this.createdCar),
      carId: carId ?? this.carId,
    );
  }

  AddCarState populateFromUserCar(UserCar? car) {
    if (car == null) return this;
    return copyWith(
      carId: car.id,
      name: car.name,
      brand: car.brand,
      model: car.model,
      color: car.colorName,
      plateNumber: car.plateNumber,
      year: car.year,
      selectedCarSizeId: car.carSizeId,
      isPrimary: car.isPrimary,
      imagePath: car.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    brand,
    model,
    color,
    plateNumber,
    year,
    carSizes,
    selectedCarSizeId,
    isPrimary,
    imagePath,
    errorMessage,
    createdCar,
    carId,
  ];
}
