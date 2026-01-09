import 'package:sudz/features/packages/data/models/models.dart';

const List<Package> kMockPackages = [
  Package(
    id: 'premium_wash',
    title: 'packages.items.premium.title',
    price: 200,
    washesCount: 3,
    validityDays: 60,
    benefits: [
      'packages.benefits.exterior_polish',
      'packages.benefits.interior_vacuum',
      'packages.benefits.rim_detailing',
    ],
    imageUrl:
        'https://images.pexels.com/photos/4870705/pexels-photo-4870705.jpeg?auto=compress&cs=tinysrgb&w=640',
    isRecommended: true,
  ),
  Package(
    id: 'classic_wash',
    title: 'packages.items.classic.title',
    price: 120,
    washesCount: 2,
    validityDays: 30,
    benefits: [
      'packages.benefits.quick_exterior',
      'packages.benefits.interior_wipe',
      'packages.benefits.window_clean',
    ],
    imageUrl:
        'https://images.pexels.com/photos/8985363/pexels-photo-8985363.jpeg?auto=compress&cs=tinysrgb&w=640',
  ),
  Package(
    id: 'luxury_wash',
    title: 'packages.items.luxury.title',
    price: 350,
    washesCount: 5,
    validityDays: 90,
    benefits: [
      'packages.benefits.deep_detail',
      'packages.benefits.engine_clean',
      'packages.benefits.ceramic_finish',
    ],
    imageUrl:
        'https://images.pexels.com/photos/1402787/pexels-photo-1402787.jpeg?auto=compress&cs=tinysrgb&w=640',
  ),
];
