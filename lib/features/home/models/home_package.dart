import 'package:equatable/equatable.dart';
import 'package:sudz/features/packages/domain/entities/package.dart';

class HomePackage extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String priceUnit;
  final String description;
  final int ordersCount;
  final int durationMinutes;

  const HomePackage({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.priceUnit,
    required this.description,
    required this.ordersCount,
    required this.durationMinutes,
  });

  /// Factory to convert Package entity to HomePackage
  factory HomePackage.fromPackage(Package package) {
    return HomePackage(
      id: package.id,
      title: package.title,
      imageUrl: package.imageUrl ??
          'https://images.unsplash.com/photo-1619767886558-efdc259cde1a?auto=format&fit=crop&w=900&q=80',
      price: package.price,
      priceUnit: 'ريال',
      description: package.description ?? '',
      ordersCount: 0, // This would come from analytics/stats API
      durationMinutes: 60, // Default duration, could be added to Package entity if needed
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        price,
        priceUnit,
        description,
        ordersCount,
        durationMinutes,
      ];
}
