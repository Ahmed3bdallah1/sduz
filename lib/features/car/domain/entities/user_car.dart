import 'package:equatable/equatable.dart';

class UserCar extends Equatable {
  const UserCar({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.colorName,
    required this.plateNumber,
    this.year,
    this.imageUrl,
    this.carSizeId,
    this.carSizeName,
    this.isPrimary = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String brand;
  final String model;
  final String colorName;
  final String plateNumber;
  final int? year;
  final String? imageUrl;
  final int? carSizeId;
  final String? carSizeName;
  final bool isPrimary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayName {
    if (name.trim().isNotEmpty) return name.trim();
    final parts = <String>[
      if (brand.trim().isNotEmpty) brand.trim(),
      if (model.trim().isNotEmpty) model.trim(),
    ];
    if (parts.isEmpty) return 'سيارة';
    return parts.join(' ');
  }

  UserCar copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? colorName,
    String? plateNumber,
    int? year,
    String? imageUrl,
    int? carSizeId,
    String? carSizeName,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserCar(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      colorName: colorName ?? this.colorName,
      plateNumber: plateNumber ?? this.plateNumber,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
      carSizeId: carSizeId ?? this.carSizeId,
      carSizeName: carSizeName ?? this.carSizeName,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    brand,
    model,
    colorName,
    plateNumber,
    year,
    imageUrl,
    carSizeId,
    carSizeName,
    isPrimary,
    createdAt,
    updatedAt,
  ];
}
