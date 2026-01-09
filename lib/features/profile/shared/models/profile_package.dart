import 'package:equatable/equatable.dart';
import 'package:sudz/features/packages/domain/entities/user_package.dart';

class ProfilePackage extends Equatable {
  final String id;
  final String name;
  final double price;
  final int totalWashes;
  final int validityDays;
  final List<String> benefits;
  final String imageUrl;
  final int? washesRemaining;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final String? status;

  const ProfilePackage({
    required this.id,
    required this.name,
    required this.price,
    required this.totalWashes,
    required this.validityDays,
    required this.benefits,
    required this.imageUrl,
    this.washesRemaining,
    this.purchaseDate,
    this.expiryDate,
    this.status,
  });

  bool get isActive => status == 'active' && (washesRemaining ?? 0) > 0;
  bool get isExpired => 
      status == 'expired' || 
      (expiryDate != null && expiryDate!.isBefore(DateTime.now()));

  ProfilePackage copyWith({
    String? id,
    String? name,
    double? price,
    int? totalWashes,
    int? validityDays,
    List<String>? benefits,
    String? imageUrl,
    int? washesRemaining,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? status,
  }) {
    return ProfilePackage(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      totalWashes: totalWashes ?? this.totalWashes,
      validityDays: validityDays ?? this.validityDays,
      benefits: benefits ?? this.benefits,
      imageUrl: imageUrl ?? this.imageUrl,
      washesRemaining: washesRemaining ?? this.washesRemaining,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
    );
  }

  factory ProfilePackage.fromUserPackage(UserPackage userPackage) {
    return ProfilePackage(
      id: userPackage.id,
      name: userPackage.packageTitle,
      price: 0.0, // Price is not available in UserPackage as it's already purchased
      totalWashes: userPackage.washesCount,
      validityDays: userPackage.validityDays,
      benefits: userPackage.benefits ?? [],
      imageUrl: userPackage.packageImageUrl ?? 
          'https://images.pexels.com/photos/4870705/pexels-photo-4870705.jpeg?auto=compress&cs=tinysrgb&w=640',
      washesRemaining: userPackage.washesRemaining,
      purchaseDate: userPackage.purchaseDate,
      expiryDate: userPackage.expiryDate,
      status: userPackage.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        totalWashes,
        validityDays,
        benefits,
        imageUrl,
        washesRemaining,
        purchaseDate,
        expiryDate,
        status,
      ];
}
