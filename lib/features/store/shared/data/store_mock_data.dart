import 'package:flutter/material.dart';
import 'package:sudz/features/store/shared/models/models.dart';

const Color kStoreIconBackground = Color(0xFFB9CCE9);

const List<StoreCategory> kStoreCategories = [
  StoreCategory(
    id: 'oils',
    nameKey: 'store.category.oils',
    icon: Icons.oil_barrel_rounded,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'water',
    nameKey: 'store.category.water',
    icon: Icons.water_drop_outlined,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'parts',
    nameKey: 'store.category.parts',
    icon: Icons.directions_car_filled_outlined,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'battery',
    nameKey: 'store.category.batteries',
    icon: Icons.battery_charging_full_outlined,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'cleaning',
    nameKey: 'store.category.cleaning',
    icon: Icons.cleaning_services_outlined,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'tools',
    nameKey: 'store.category.tools',
    icon: Icons.handyman_outlined,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'lighting',
    nameKey: 'store.category.lighting',
    icon: Icons.lightbulb_outline,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'tires',
    nameKey: 'store.category.tires',
    icon: Icons.blur_circular_outlined,
    iconBackground: kStoreIconBackground,
  ),
  StoreCategory(
    id: 'filters',
    nameKey: 'store.category.filters',
    icon: Icons.filter_alt_outlined,
    iconBackground: kStoreIconBackground,
  ),
];

const List<StoreFilterOption> kDefaultFilters = [
  StoreFilterOption(id: 'all', labelKey: 'store.filter.all'),
  StoreFilterOption(id: 'type1', labelKey: 'store.filter.type1'),
  StoreFilterOption(id: 'type2', labelKey: 'store.filter.type2'),
  StoreFilterOption(id: 'type3', labelKey: 'store.filter.type3'),
  StoreFilterOption(id: 'type4', labelKey: 'store.filter.type4'),
  StoreFilterOption(id: 'type5', labelKey: 'store.filter.type5'),
];

final List<StoreProduct> kStoreProducts = [
  for (final category in kStoreCategories)
    for (int index = 0; index < 6; index++)
      StoreProduct(
        id: '${category.id}-product-${index + 1}',
        categoryId: category.id,
        nameKey: 'store.product.name',
        descriptionKey: 'store.product.description',
        price: 18.9 + index,
        oldPrice: index.isEven ? 21.4 + index : null,
        imageUrl:
            'https://images.unsplash.com/photo-1582719478173-e88e26f2219f?auto=format&fit=crop&w=600&q=80',
      ),
];

final Map<String, List<StoreProduct>> kStoreProductsByCategory = {
  for (final category in kStoreCategories)
    category.id: kStoreProducts
        .where((product) => product.categoryId == category.id)
        .toList(),
};

final List<StoreCartItem> kInitialCartItems = [
  StoreCartItem(
    product: kStoreProducts.first,
    quantity: 2,
  ),
  StoreCartItem(
    product: kStoreProducts[1],
    quantity: 1,
  ),
  StoreCartItem(
    product: kStoreProducts[2],
    quantity: 3,
  ),
];

const List<StorePaymentMethod> kStorePaymentMethods = [
  StorePaymentMethod(
    id: 'cash',
    nameKey: 'store.payment.cash',
    type: StorePaymentType.cash,
  ),
  StorePaymentMethod(
    id: 'tabby',
    nameKey: 'store.payment.tabby',
    maskedNumber: '*** 000',
    type: StorePaymentType.provider,
    isDefault: true,
  ),
  StorePaymentMethod(
    id: 'tamara',
    nameKey: 'store.payment.tamara',
    maskedNumber: '*** 000',
    type: StorePaymentType.provider,
  ),
  StorePaymentMethod(
    id: 'visa',
    nameKey: 'store.payment.visa',
    maskedNumber: '**** 1234',
    type: StorePaymentType.card,
  ),
  StorePaymentMethod(
    id: 'apple-pay',
    nameKey: 'store.payment.apple_pay',
    maskedNumber: '**** 9876',
    type: StorePaymentType.provider,
  ),
];
