import 'package:equatable/equatable.dart';

class Service extends Equatable {
  const Service({
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

  Service copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    int? durationMinutes,
    List<String>? features,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        categoryId,
        categoryName,
        imageUrl,
        durationMinutes,
        features,
        isActive,
        createdAt,
        updatedAt,
      ];
}

