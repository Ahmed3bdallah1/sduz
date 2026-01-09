import 'package:equatable/equatable.dart';

class ServiceScheduleEvent extends Equatable {
  const ServiceScheduleEvent();

  @override
  List<Object?> get props => [];
}

class ServiceScheduleStarted extends ServiceScheduleEvent {
  const ServiceScheduleStarted();
}

class ServiceScheduleDayChanged extends ServiceScheduleEvent {
  final int dayIndex;

  const ServiceScheduleDayChanged(this.dayIndex);

  @override
  List<Object?> get props => [dayIndex];
}

class ServiceScheduleSlotSelected extends ServiceScheduleEvent {
  final String slotId;

  const ServiceScheduleSlotSelected(this.slotId);

  @override
  List<Object?> get props => [slotId];
}

class ServiceScheduleContinuePressed extends ServiceScheduleEvent {
  const ServiceScheduleContinuePressed();
}

class ServiceScheduleAlternateRequested extends ServiceScheduleEvent {
  const ServiceScheduleAlternateRequested();
}

class ServiceScheduleNavigationHandled extends ServiceScheduleEvent {
  const ServiceScheduleNavigationHandled();
}
