import '../../../../core/models/json_types.dart';
import '../../domain/entities/service.dart';

class ServiceDto {
  const ServiceDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.categoryId,
    this.categoryName,
    this.imageUrl,
    this.durationMinutes,
    this.features,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String? categoryId;
  final String? categoryName;
  final String? imageUrl;
  final int? durationMinutes;
  final List<String>? features;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ServiceDto.fromJson(JsonMap json) {
    // Handle nested category data
    final categoryData = json['category'] as JsonMap?;

    return ServiceDto(
      id: _stringify(json['id']) ?? _stringify(json['uuid']) ?? '',
      title: _stringify(json['title'] ?? json['name']) ?? 'Service',
      description: _stringify(json['description'] ?? json['details']) ?? '',
      price: _toDouble(json['price'] ?? json['cost'] ?? json['amount']) ?? 0.0,
      categoryId: _stringify(
        json['category_id'] ?? 
        json['service_category_id'] ?? 
        categoryData?['id']
      ),
      categoryName: _stringify(
        json['category_name'] ?? 
        categoryData?['name'] ?? 
        categoryData?['title']
      ),
      imageUrl: _stringify(
        json['image_url'] ?? 
        json['image'] ?? 
        json['photo'] ?? 
        json['thumbnail']
      ),
      durationMinutes: _toInt(
        json['duration_minutes'] ?? 
        json['duration'] ?? 
        json['estimated_time']
      ),
      features: _toFeaturesList(
        json['features'] ?? 
        json['benefits'] ?? 
        json['includes']
      ),
      isActive: _toBool(json['is_active'] ?? json['active']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  JsonMap toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'category_name': categoryName,
      'image_url': imageUrl,
      'duration_minutes': durationMinutes,
      'features': features,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  Service toEntity() {
    return Service(
      id: id,
      title: title,
      description: description,
      price: price,
      categoryId: categoryId,
      categoryName: categoryName,
      imageUrl: imageUrl,
      durationMinutes: durationMinutes,
      features: features,
      isActive: isActive,
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
    if (value == null) return true; // Default to true (active)
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' ||
          normalized == '1' ||
          normalized == 'yes' ||
          normalized == 'on' ||
          normalized == 'active';
    }
    return true;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static List<String>? _toFeaturesList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value
          .map((item) {
            if (item is String) return item.trim();
            if (item is Map<String, dynamic>) {
              return _stringify(item['name'] ?? item['title'] ?? item['feature']);
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
    return null;
  }
}

