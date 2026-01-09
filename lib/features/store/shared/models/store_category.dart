import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StoreCategory extends Equatable {
  final String id;
  final String nameKey;
  final IconData icon;
  final Color iconBackground;

  const StoreCategory({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.iconBackground,
  });

  @override
  List<Object?> get props => [id, nameKey, icon, iconBackground];
}
