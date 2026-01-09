import '../../../../core/models/json_types.dart';
import '../../domain/entities/package.dart';

class PackageDto {
  const PackageDto({
    required this.id,
    required this.title,
    required this.price,
    required this.washesCount,
    required this.validityDays,
    required this.benefits,
    this.imageUrl,
    this.isRecommended = false,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final double price;
  final int washesCount;
  final int validityDays;
  final List<String> benefits;
  final String? imageUrl;
  final bool isRecommended;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PackageDto.fromJson(JsonMap json) {
    return PackageDto(
      id: _stringify(json['id']) ?? _stringify(json['uuid']) ?? '',
      title: _stringify(json['title'] ?? json['name']) ?? 'Package',
      price: _toDouble(json['price'] ?? json['amount']) ?? 0.0,
      washesCount: _toInt(json['washes_count'] ?? json['washes'] ?? json['services_count']) ?? 0,
      validityDays: _toInt(json['validity_days'] ?? json['valid_for_days'] ?? json['duration_days']) ?? 30,
      benefits: _toBenefitsList(json['benefits'] ?? json['features'] ?? json['services']),
      imageUrl: _stringify(json['image_url'] ?? json['image'] ?? json['photo']),
      isRecommended: _toBool(json['is_recommended'] ?? json['recommended']),
      description: _stringify(json['description'] ?? json['details']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  JsonMap toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'washes_count': washesCount,
      'validity_days': validityDays,
      'benefits': benefits,
      'image_url': imageUrl,
      'is_recommended': isRecommended,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  Package toEntity() {
    return Package(
      id: id,
      title: title,
      price: price,
      washesCount: washesCount,
      validityDays: validityDays,
      benefits: benefits,
      imageUrl: imageUrl,
      isRecommended: isRecommended,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static List<String> _toBenefitsList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((item) {
            if (item is String) return item.trim();
            if (item is Map<String, dynamic>) {
              return _stringify(item['name'] ?? item['title'] ?? item['benefit']);
            }
            return item.toString();
          })
          .whereType<String>()
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (value is String) {
      return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }
}

