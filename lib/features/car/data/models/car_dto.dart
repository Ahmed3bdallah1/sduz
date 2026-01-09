import '../../../../core/models/json_types.dart';
import '../../domain/entities/user_car.dart';

class CarDto {
  const CarDto({
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

  factory CarDto.fromJson(JsonMap json) {
    return CarDto(
      id: _stringify(json['id']) ?? '',
      name: _stringify(json['name']) ?? _fallbackName(json),
      brand: _stringify(json['brand']) ?? '',
      model: _stringify(json['model']) ?? '',
      colorName:
          _stringify(json['color']) ?? _stringify(json['color_name']) ?? '',
      plateNumber: _stringify(json['plate_number']) ?? '',
      year: _toInt(json['year']),
      imageUrl:
          _stringify(json['image_url']) ??
          _stringify(json['image']) ??
          _extractImage(json['media']),
      carSizeId: _toInt(json['car_size_id']),
      carSizeName:
          _stringify(json['car_size_name']) ?? _stringify(json['size_name']),
      isPrimary: _toBool(json['is_primary']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  UserCar toEntity() {
    return UserCar(
      id: id,
      name: name,
      brand: brand,
      model: model,
      colorName: colorName,
      plateNumber: plateNumber,
      year: year,
      imageUrl: imageUrl,
      carSizeId: carSizeId,
      carSizeName: carSizeName,
      isPrimary: isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static String _fallbackName(JsonMap json) {
    final brand = _stringify(json['brand']) ?? '';
    final model = _stringify(json['model']) ?? '';
    if (brand.isEmpty && model.isEmpty) return 'سيارة';
    return '$brand $model'.trim();
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.trim();
    return value.toString();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value.trim());
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
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static String? _extractImage(dynamic media) {
    if (media is JsonMap) {
      return _stringify(media['url']) ?? _stringify(media['thumb']);
    }
    if (media is List && media.isNotEmpty) {
      final first = media.first;
      if (first is JsonMap) {
        return _stringify(first['url']) ?? _stringify(first['thumb']);
      }
    }
    return null;
  }
}
