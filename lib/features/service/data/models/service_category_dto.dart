import '../../../../core/models/json_types.dart';
import '../../domain/entities/service_category.dart';

class ServiceCategoryDto {
  const ServiceCategoryDto({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.imageUrl,
    this.isActive = true,
    this.displayOrder,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final String? imageUrl;
  final bool isActive;
  final int? displayOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ServiceCategoryDto.fromJson(JsonMap json) {
    return ServiceCategoryDto(
      id: _stringify(json['id']) ?? _stringify(json['uuid']) ?? '',
      name: _stringify(json['name'] ?? json['title']) ?? 'Category',
      description: _stringify(json['description'] ?? json['details']),
      iconUrl: _stringify(json['icon_url'] ?? json['icon']),
      imageUrl: _stringify(json['image_url'] ?? json['image'] ?? json['photo']),
      isActive: _toBool(json['is_active'] ?? json['active']),
      displayOrder: _toInt(json['display_order'] ?? json['order'] ?? json['sort_order']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  JsonMap toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'image_url': imageUrl,
      'is_active': isActive,
      'display_order': displayOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  ServiceCategory toEntity() {
    return ServiceCategory(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      imageUrl: imageUrl,
      isActive: isActive,
      displayOrder: displayOrder,
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
}

