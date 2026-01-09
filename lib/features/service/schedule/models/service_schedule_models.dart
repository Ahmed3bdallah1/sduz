import 'package:equatable/equatable.dart';

import 'package:sudz/features/service/models/models.dart';

import '../../../car/models/service_car.dart';

class ServiceTimeSlot extends Equatable {
  final String id;
  final String displayLabel;
  final bool isAvailable;
  final bool isRecommended;

  const ServiceTimeSlot({
    required this.id,
    required this.displayLabel,
    this.isAvailable = true,
    this.isRecommended = false,
  });

  ServiceTimeSlot copyWith({
    String? id,
    String? displayLabel,
    bool? isAvailable,
    bool? isRecommended,
  }) {
    return ServiceTimeSlot(
      id: id ?? this.id,
      displayLabel: displayLabel ?? this.displayLabel,
      isAvailable: isAvailable ?? this.isAvailable,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }

  @override
  List<Object?> get props => [id, displayLabel, isAvailable, isRecommended];
}

class ServiceScheduleDay extends Equatable {
  final DateTime date;
  final String dayLabel;
  final String dayNumber;
  final bool isToday;
  final List<ServiceTimeSlot> slots;

  const ServiceScheduleDay({
    required this.date,
    required this.dayLabel,
    required this.dayNumber,
    this.isToday = false,
    this.slots = const [],
  });

  @override
  List<Object?> get props => [date, dayLabel, dayNumber, isToday, slots];
}

class ServiceScheduleParams extends Equatable {
  final ServiceCar car;
  final ServiceType serviceType;
  final ServicePackage? activePackage;

  const ServiceScheduleParams({
    required this.car,
    required this.serviceType,
    this.activePackage,
  });

  bool get hasActivePackage {
    final package = activePackage;
    if (package == null) return false;
    return package.isEnabled && package.remainingWashes > 0;
  }

  @override
  List<Object?> get props => [car, serviceType, activePackage];
}

class ServiceScheduleSelection extends Equatable {
  final ServiceScheduleDay day;
  final ServiceTimeSlot slot;

  const ServiceScheduleSelection({required this.day, required this.slot});

  @override
  List<Object?> get props => [day, slot];
}
