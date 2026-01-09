import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sudz/features/service/domain/entities/service_category.dart';

class HomeCategory extends Equatable {
  final String id;
  final String title;
  final IconData icon;
  final Color backgroundColor;

  const HomeCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.backgroundColor,
  });

  /// Factory to convert ServiceCategory to HomeCategory
  factory HomeCategory.fromServiceCategory(ServiceCategory category) {
    // Map category names to icons (you can customize this mapping)
    IconData icon;
    Color backgroundColor;

    switch (category.name.toLowerCase()) {
      case 'غسيل':
      case 'wash':
      case 'washing':
        icon = Icons.local_car_wash_outlined;
        backgroundColor = const Color(0xFFEFE5FF);
        break;
      case 'تلميع':
      case 'polish':
      case 'polishing':
        icon = Icons.auto_fix_high_outlined;
        backgroundColor = const Color(0xFFE1F2FF);
        break;
      case 'صيانة':
      case 'maintenance':
        icon = Icons.build_outlined;
        backgroundColor = const Color(0xFFFFF0E6);
        break;
      default:
        icon = Icons.more_horiz;
        backgroundColor = const Color(0xFFF0F4F8);
    }

    return HomeCategory(
      id: category.id,
      title: category.name,
      icon: icon,
      backgroundColor: backgroundColor,
    );
  }

  @override
  List<Object?> get props => [id, title, icon, backgroundColor];
}
