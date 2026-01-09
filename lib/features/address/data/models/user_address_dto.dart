import '../../../../core/models/json_types.dart';
import '../../domain/entities/user_address.dart';

class UserAddressDto {
  const UserAddressDto({
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

  factory UserAddressDto.fromJson(JsonMap json) {
    return UserAddressDto(
      id: _stringify(json['id']) ?? _stringify(json['uuid']) ?? '',
      title: _stringify(json['title']) ?? 'بدون عنوان',
      description: _stringify(json['description']),
      latitude: _toDouble(json['lat'] ?? json['latitude']),
      longitude: _toDouble(json['lng'] ?? json['longitude']),
      city: _stringify(
        json['city'] ??
            json['city_name'] ??
            (json['location'] is Map<String, dynamic>
                ? (json['location'] as JsonMap)['city']
                : null),
      ),
      district: _stringify(json['district'] ?? json['area']),
      streetName: _stringify(json['street_name'] ?? json['street']),
      buildingNumber: _stringify(json['building_number']),
      addressType: _stringify(json['address_type']),
      isDefault: _toBool(
        json['is_default'] ??
            json['default'] ??
            (json['metadata'] is Map<String, dynamic>
                ? (json['metadata'] as JsonMap)['is_default']
                : null),
      ),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      formattedAddress: _stringify(
        json['formatted_address'] ??
            _extractNestedFormatted(json) ??
            _guessFormatted(json),
      ),
    );
  }

  JsonMap toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'lat': latitude,
      'lng': longitude,
      'city': city,
      'district': district,
      'street_name': streetName,
      'building_number': buildingNumber,
      'address_type': addressType,
      'is_default': isDefault,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'formatted_address': formattedAddress,
    }..removeWhere((key, value) => value == null);
  }

  UserAddress toEntity() {
    return UserAddress(
      id: id,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      city: city,
      district: district,
      streetName: streetName,
      buildingNumber: buildingNumber,
      addressType: addressType,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
      formattedAddress: formattedAddress,
    );
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim().isEmpty ? null : value.trim();
    }
    return value.toString();
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes' ||
          normalized == 'on';
    }
    return false;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static String? _extractNestedFormatted(JsonMap json) {
    final location = json['location'];
    if (location is Map<String, dynamic>) {
      final nested = location['formatted_address'] ?? location['description'];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
    }
    return null;
  }

  static String? _guessFormatted(JsonMap json) {
    final parts =
        [
              _stringify(json['district']),
              _stringify(json['street_name']),
              _stringify(json['building_number']),
              _stringify(json['city']),
            ]
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }
}
