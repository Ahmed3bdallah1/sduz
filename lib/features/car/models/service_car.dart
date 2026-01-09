import 'package:equatable/equatable.dart';

import '../domain/entities/user_car.dart';

/// Represents a user's saved car that can be used in services.
class ServiceCar extends Equatable {
  final String id;
  final String displayName;
  final String colorName;
  final String plateNumber;
  final String? imageUrl;
  final bool isPrimary;
  final String? brand;
  final String? model;
  final int? year;
  final int? carSizeId;
  final String? carSizeName;

  const ServiceCar({
    required this.id,
    required this.displayName,
    required this.colorName,
    required this.plateNumber,
    this.imageUrl,
    this.isPrimary = false,
    this.brand,
    this.model,
    this.year,
    this.carSizeId,
    this.carSizeName,
  });

  ServiceCar copyWith({
    String? id,
    String? displayName,
    String? colorName,
    String? plateNumber,
    String? imageUrl,
    bool? isPrimary,
    String? brand,
    String? model,
    int? year,
    int? carSizeId,
    String? carSizeName,
  }) {
    return ServiceCar(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      colorName: colorName ?? this.colorName,
      plateNumber: plateNumber ?? this.plateNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      isPrimary: isPrimary ?? this.isPrimary,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      carSizeId: carSizeId ?? this.carSizeId,
      carSizeName: carSizeName ?? this.carSizeName,
    );
  }

  factory ServiceCar.fromUserCar(UserCar car) {
    return ServiceCar(
      id: car.id,
      displayName: car.displayName,
      colorName: car.colorName,
      plateNumber: car.plateNumber,
      imageUrl: car.imageUrl,
      isPrimary: car.isPrimary,
      brand: car.brand,
      model: car.model,
      year: car.year,
      carSizeId: car.carSizeId,
      carSizeName: car.carSizeName,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    colorName,
    plateNumber,
    imageUrl,
    isPrimary,
    brand,
    model,
    year,
    carSizeId,
    carSizeName,
  ];
}
