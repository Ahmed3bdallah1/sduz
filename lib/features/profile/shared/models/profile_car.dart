import 'package:equatable/equatable.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';

class ProfileCar extends Equatable {
  final String id;
  final String make;
  final String model;
  final String colorName;
  final String plateNumber;
  final String imageUrl;
  final bool isPrimary;

  const ProfileCar({
    required this.id,
    required this.make,
    required this.model,
    required this.colorName,
    required this.plateNumber,
    required this.imageUrl,
    this.isPrimary = false,
  });

  ProfileCar copyWith({
    String? id,
    String? make,
    String? model,
    String? colorName,
    String? plateNumber,
    String? imageUrl,
    bool? isPrimary,
  }) {
    return ProfileCar(
      id: id ?? this.id,
      make: make ?? this.make,
      model: model ?? this.model,
      colorName: colorName ?? this.colorName,
      plateNumber: plateNumber ?? this.plateNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  String get fullDescription => '$make , $model , $colorName';

  factory ProfileCar.fromUserCar(UserCar car) {
    return ProfileCar(
      id: car.id,
      make: car.brand,
      model: car.model,
      colorName: car.colorName,
      plateNumber: car.plateNumber,
      imageUrl:
          car.imageUrl ??
          'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?auto=format&fit=crop&w=400&q=80',
      isPrimary: car.isPrimary,
    );
  }

  @override
  List<Object?> get props => [
    id,
    make,
    model,
    colorName,
    plateNumber,
    imageUrl,
    isPrimary,
  ];
}
