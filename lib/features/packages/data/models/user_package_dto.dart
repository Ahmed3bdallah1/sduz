import '../../../../core/models/json_types.dart';
import '../../domain/entities/user_package.dart';

class UserPackageDto {
  const UserPackageDto({
    required this.id,
    required this.packageId,
    required this.packageTitle,
    required this.washesCount,
    required this.washesRemaining,
    required this.validityDays,
    required this.purchaseDate,
    required this.expiryDate,
    required this.status,
    this.packageImageUrl,
    this.benefits,
  });

  final String id;
  final String packageId;
  final String packageTitle;
  final int washesCount;
  final int washesRemaining;
  final int validityDays;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String status;
  final String? packageImageUrl;
  final List<String>? benefits;

  factory UserPackageDto.fromJson(JsonMap json) {
    // Handle nested package data
    final packageData = json['package'] as JsonMap?;
    
    return UserPackageDto(
      id: _stringify(json['id']) ?? _stringify(json['uuid']) ?? '',
      packageId: _stringify(json['package_id'] ?? packageData?['id']) ?? '',
      packageTitle: _stringify(
        json['package_title'] ?? 
        json['title'] ?? 
        packageData?['title'] ?? 
        packageData?['name']
      ) ?? 'Package',
      washesCount: _toInt(
        json['washes_count'] ?? 
        json['total_washes'] ?? 
        packageData?['washes_count']
      ) ?? 0,
      washesRemaining: _toInt(
        json['washes_remaining'] ?? 
        json['remaining_washes'] ?? 
        json['remaining']
      ) ?? 0,
      validityDays: _toInt(
        json['validity_days'] ?? 
        packageData?['validity_days']
      ) ?? 30,
      purchaseDate: _toDate(json['purchase_date'] ?? json['purchased_at']) ?? DateTime.now(),
      expiryDate: _toDate(json['expiry_date'] ?? json['expires_at'] ?? json['valid_until']) ?? DateTime.now(),
      status: _stringify(json['status']) ?? 'active',
      packageImageUrl: _stringify(
        json['package_image_url'] ?? 
        packageData?['image_url'] ?? 
        packageData?['image']
      ),
      benefits: _toBenefitsList(
        json['benefits'] ?? 
        packageData?['benefits'] ?? 
        packageData?['features']
      ),
    );
  }

  JsonMap toJson() {
    return <String, dynamic>{
      'id': id,
      'package_id': packageId,
      'package_title': packageTitle,
      'washes_count': washesCount,
      'washes_remaining': washesRemaining,
      'validity_days': validityDays,
      'purchase_date': purchaseDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'status': status,
      'package_image_url': packageImageUrl,
      'benefits': benefits,
    }..removeWhere((key, value) => value == null);
  }

  UserPackage toEntity() {
    return UserPackage(
      id: id,
      packageId: packageId,
      packageTitle: packageTitle,
      washesCount: washesCount,
      washesRemaining: washesRemaining,
      validityDays: validityDays,
      purchaseDate: purchaseDate,
      expiryDate: expiryDate,
      status: status,
      packageImageUrl: packageImageUrl,
      benefits: benefits,
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

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  static List<String>? _toBenefitsList(dynamic value) {
    if (value == null) return null;
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
    return null;
  }
}

