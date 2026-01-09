import 'package:equatable/equatable.dart';

/// Represents a subscription package that the user can enable.
class ServicePackage extends Equatable {
  final String id;
  final String name;
  final int remainingDays;
  final int remainingWashes;
  final bool isEnabled;

  const ServicePackage({
    required this.id,
    required this.name,
    required this.remainingDays,
    required this.remainingWashes,
    this.isEnabled = true,
  });

  ServicePackage copyWith({
    String? id,
    String? name,
    int? remainingDays,
    int? remainingWashes,
    bool? isEnabled,
  }) {
    return ServicePackage(
      id: id ?? this.id,
      name: name ?? this.name,
      remainingDays: remainingDays ?? this.remainingDays,
      remainingWashes: remainingWashes ?? this.remainingWashes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        remainingDays,
        remainingWashes,
        isEnabled,
      ];
}
