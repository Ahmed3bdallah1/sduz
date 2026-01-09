import 'package:sudz/features/profile/shared/models/models.dart';

const String kProfileUserName = 'عبدالله';

const List<ProfileQuickLink> kProfileQuickLinks = [
  ProfileQuickLink(
    id: 'cars',
    titleKey: 'profile.quick_links.cars',
    iconAsset: 'assets/icons/car-vehicle 1.svg',

  ),
  ProfileQuickLink(
    id: 'packages',
    titleKey: 'profile.quick_links.packages',
    iconAsset: 'assets/icons/marketing-outline-paper 1.svg',

  ),
  ProfileQuickLink(
    id: 'gifts',
    titleKey: 'profile.quick_links.gifts',
    iconAsset: 'assets/icons/gift 1.svg',

  ),
  ProfileQuickLink(
    id: 'language',
    titleKey: 'profile.quick_links.language',
    iconAsset: 'assets/icons/language 1.svg',

  ),
];

const List<ProfilePolicyItem> kProfilePolicyItems = [
  ProfilePolicyItem(
    id: 'privacy',
    titleKey: 'profile.policies.privacy',
    iconAsset: 'assets/icons/data--privacy_1_.svg',
  ),
  ProfilePolicyItem(
    id: 'reservation',
    titleKey: 'profile.policies.reservation',
    iconAsset: 'assets/icons/refund 2.svg',
  ),
];

const List<ProfileLanguageOption> kProfileLanguages = [
  ProfileLanguageOption(code: 'ar', labelKey: 'profile.language.ar'),
  ProfileLanguageOption(code: 'en', labelKey: 'profile.language.en'),
];

const List<ProfileCar> kProfileCars = [
  ProfileCar(
    id: 'car_1',
    make: 'Toyota',
    model: 'يارس',
    colorName: 'اسود',
    plateNumber: '1234 اس',
    imageUrl:
        'https://images.pexels.com/photos/1402787/pexels-photo-1402787.jpeg?auto=compress&cs=tinysrgb&w=640',
    isPrimary: true,
  ),
  ProfileCar(
    id: 'car_2',
    make: 'Mercedes',
    model: 'C-Class',
    colorName: 'أبيض',
    plateNumber: '2579 اج',
    imageUrl:
        'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg?auto=compress&cs=tinysrgb&w=640',
  ),
  ProfileCar(
    id: 'car_3',
    make: 'Hyundai',
    model: 'سوناتا',
    colorName: 'رمادي',
    plateNumber: '8890 ره',
    imageUrl:
        'https://images.pexels.com/photos/452112/pexels-photo-452112.jpeg?auto=compress&cs=tinysrgb&w=640',
  ),
];

const List<ProfilePackage> kProfilePackages = [
  ProfilePackage(
    id: 'package_1',
    name: 'غسيل ممتاز',
    price: 200,
    totalWashes: 3,
    validityDays: 60,
    benefits: [
      'profile.packages.benefits.exterior_detail',
      'profile.packages.benefits.interior_vacuum',
      'profile.packages.benefits.wheel_shine',
    ],
    imageUrl:
        'https://images.pexels.com/photos/4870705/pexels-photo-4870705.jpeg?auto=compress&cs=tinysrgb&w=640',
  ),
  ProfilePackage(
    id: 'package_2',
    name: 'غسيل سريع',
    price: 120,
    totalWashes: 2,
    validityDays: 30,
    benefits: [
      'profile.packages.benefits.quick_exterior',
      'profile.packages.benefits.glass_clean',
      'profile.packages.benefits.cabin_freshener',
    ],
    imageUrl:
        'https://images.pexels.com/photos/8985363/pexels-photo-8985363.jpeg?auto=compress&cs=tinysrgb&w=640',
  ),
];

const List<ProfileDedicationType> kProfileDedicationTypes = [
  ProfileDedicationType(id: 'premium_clean', title: 'إهداء غسيل ممتاز'),
  ProfileDedicationType(id: 'quick_clean', title: 'إهداء غسيل سريع'),
  ProfileDedicationType(id: 'full_detail', title: 'إهداء تلميع كامل'),
  ProfileDedicationType(id: 'vip', title: 'إهداء VIP'),
];
