import 'package:equatable/equatable.dart';

class StoreProduct extends Equatable {
  final String id;
  final String categoryId;
  final String nameKey;
  final String descriptionKey;
  final double price;
  final double? oldPrice;
  final String imageUrl;

  const StoreProduct({
    required this.id,
    required this.categoryId,
    required this.nameKey,
    required this.descriptionKey,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        nameKey,
        descriptionKey,
        price,
        oldPrice,
        imageUrl,
      ];
}
