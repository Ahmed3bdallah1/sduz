import 'package:equatable/equatable.dart';

/// Represents a package purchased by the user
class UserPackage extends Equatable {
  const UserPackage({
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
  final String status; // 'active', 'expired', 'used'
  final String? packageImageUrl;
  final List<String>? benefits;

  bool get isActive => status == 'active' && washesRemaining > 0;
  bool get isExpired => status == 'expired' || expiryDate.isBefore(DateTime.now());

  UserPackage copyWith({
    String? id,
    String? packageId,
    String? packageTitle,
    int? washesCount,
    int? washesRemaining,
    int? validityDays,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? status,
    String? packageImageUrl,
    List<String>? benefits,
  }) {
    return UserPackage(
      id: id ?? this.id,
      packageId: packageId ?? this.packageId,
      packageTitle: packageTitle ?? this.packageTitle,
      washesCount: washesCount ?? this.washesCount,
      washesRemaining: washesRemaining ?? this.washesRemaining,
      validityDays: validityDays ?? this.validityDays,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      packageImageUrl: packageImageUrl ?? this.packageImageUrl,
      benefits: benefits ?? this.benefits,
    );
  }

  @override
  List<Object?> get props => [
        id,
        packageId,
        packageTitle,
        washesCount,
        washesRemaining,
        validityDays,
        purchaseDate,
        expiryDate,
        status,
        packageImageUrl,
        benefits,
      ];
}

