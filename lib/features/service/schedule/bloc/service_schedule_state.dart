import 'package:equatable/equatable.dart';

import '../models/models.dart';

enum ServiceScheduleStatus { initial, loading, ready, failure }

extension ServiceScheduleStatusX on ServiceScheduleStatus {
  bool get isInitial => this == ServiceScheduleStatus.initial;
  bool get isLoading => this == ServiceScheduleStatus.loading;
  bool get isReady => this == ServiceScheduleStatus.ready;
  bool get isFailure => this == ServiceScheduleStatus.failure;
}

class ServiceScheduleState extends Equatable {
  final ServiceScheduleStatus status;
  final List<ServiceScheduleDay> days;
  final int selectedDayIndex;
  final String? selectedSlotId;
  final String? errorMessage;
  final bool alternateRequested;
  final bool navigateNext;

  const ServiceScheduleState({
    this.status = ServiceScheduleStatus.initial,
    this.days = const [],
    this.selectedDayIndex = 0,
    this.selectedSlotId,
    this.errorMessage,
    this.alternateRequested = false,
    this.navigateNext = false,
  });

  ServiceScheduleState copyWith({
    ServiceScheduleStatus? status,
    List<ServiceScheduleDay>? days,
    int? selectedDayIndex,
    String? selectedSlotId,
    bool overrideSelectedSlot = false,
    String? errorMessage,
    bool overrideErrorMessage = false,
    bool? alternateRequested,
    bool? navigateNext,
  }) {
    return ServiceScheduleState(
      status: status ?? this.status,
      days: days ?? this.days,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      selectedSlotId: overrideSelectedSlot
          ? selectedSlotId
          : (selectedSlotId ?? this.selectedSlotId),
      errorMessage: overrideErrorMessage
          ? errorMessage
          : (errorMessage ?? this.errorMessage),
      alternateRequested: alternateRequested ?? this.alternateRequested,
      navigateNext: navigateNext ?? this.navigateNext,
    );
  }

  ServiceScheduleDay? get selectedDay {
    if (selectedDayIndex < 0 || selectedDayIndex >= days.length) {
      return null;
    }
    return days[selectedDayIndex];
  }

  ServiceTimeSlot? get selectedSlot {
    final day = selectedDay;
    if (day == null || selectedSlotId == null) return null;
    for (final slot in day.slots) {
      if (slot.id == selectedSlotId) {
        return slot;
      }
    }
    return null;
  }

  bool get canContinue => selectedSlot != null;

  @override
  List<Object?> get props => [
    status,
    days,
    selectedDayIndex,
    selectedSlotId,
    errorMessage,
    alternateRequested,
    navigateNext,
  ];
}
