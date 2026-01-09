import 'package:equatable/equatable.dart';

class UserAddress extends Equatable {
  const UserAddress({
    required this.id,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.city,
    this.district,
    this.streetName,
    this.buildingNumber,
    this.addressType,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
    this.formattedAddress,
  });

  final String id;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? district;
  final String? streetName;
  final String? buildingNumber;
  final String? addressType;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? formattedAddress;

  String get shortDescription {
    final formatted = formattedAddress?.trim();
    if (formatted != null && formatted.isNotEmpty) {
      return formatted;
    }
    final segments = [district, streetName, buildingNumber, city]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty);
    return segments.join(', ');
  }

  UserAddress copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    String? city,
    String? district,
    String? streetName,
    String? buildingNumber,
    String? addressType,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? formattedAddress,
  }) {
    return UserAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      district: district ?? this.district,
      streetName: streetName ?? this.streetName,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      formattedAddress: formattedAddress ?? this.formattedAddress,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    latitude,
    longitude,
    city,
    district,
    streetName,
    buildingNumber,
    addressType,
    isDefault,
    createdAt,
    updatedAt,
    formattedAddress,
  ];
}
