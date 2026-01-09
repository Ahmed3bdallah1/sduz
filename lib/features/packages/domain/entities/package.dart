import 'package:equatable/equatable.dart';

class Package extends Equatable {
  const Package({
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

  Package copyWith({
    String? id,
    String? title,
    double? price,
    int? washesCount,
    int? validityDays,
    List<String>? benefits,
    String? imageUrl,
    bool? isRecommended,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Package(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      washesCount: washesCount ?? this.washesCount,
      validityDays: validityDays ?? this.validityDays,
      benefits: benefits ?? this.benefits,
      imageUrl: imageUrl ?? this.imageUrl,
      isRecommended: isRecommended ?? this.isRecommended,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        washesCount,
        validityDays,
        benefits,
        imageUrl,
        isRecommended,
        description,
        createdAt,
        updatedAt,
      ];
}

