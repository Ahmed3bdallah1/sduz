import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import 'service_schedule_event.dart';
import 'service_schedule_state.dart';

class ServiceScheduleBloc
    extends Bloc<ServiceScheduleEvent, ServiceScheduleState> {
  ServiceScheduleBloc() : super(const ServiceScheduleState()) {
    on<ServiceScheduleStarted>(_onStarted);
    on<ServiceScheduleDayChanged>(_onDayChanged);
    on<ServiceScheduleSlotSelected>(_onSlotSelected);
    on<ServiceScheduleAlternateRequested>(_onAlternateRequested);
    on<ServiceScheduleContinuePressed>(_onContinuePressed);
    on<ServiceScheduleNavigationHandled>(_onNavigationHandled);
  }

  Future<void> _onStarted(
    ServiceScheduleStarted event,
    Emitter<ServiceScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ServiceScheduleStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 250));

    final days = _generateMockDays();

    emit(
      state.copyWith(
        status: ServiceScheduleStatus.ready,
        days: days,
        selectedDayIndex: 0,
        selectedSlotId: () {
          final initialSlot = days.first.slots.firstWhere(
            (slot) => slot.isAvailable,
            orElse: () => days.first.slots.first,
          );
          return initialSlot.isAvailable ? initialSlot.id : null;
        }(),
        overrideSelectedSlot: true,
        alternateRequested: false,
        navigateNext: false,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onDayChanged(
    ServiceScheduleDayChanged event,
    Emitter<ServiceScheduleState> emit,
  ) {
    final dayIndex = event.dayIndex;
    if (dayIndex < 0 || dayIndex >= state.days.length) {
      return;
    }

    final day = state.days[dayIndex];
    final firstAvailable = day.slots.firstWhere(
      (slot) => slot.isAvailable,
      orElse: () => day.slots.first,
    );

    emit(
      state.copyWith(
        selectedDayIndex: dayIndex,
        selectedSlotId: firstAvailable.isAvailable ? firstAvailable.id : null,
        overrideSelectedSlot: true,
        alternateRequested: false,
        navigateNext: false,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onSlotSelected(
    ServiceScheduleSlotSelected event,
    Emitter<ServiceScheduleState> emit,
  ) {
    final day = state.selectedDay;
    if (day == null) return;

    final slot = day.slots.firstWhere(
      (item) => item.id == event.slotId,
      orElse: () => day.slots.first,
    );

    if (!slot.isAvailable) {
      emit(
        state.copyWith(
          errorMessage: 'service.schedule.error_unavailable_slot',
          navigateNext: false,
          overrideErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedSlotId: slot.id,
        overrideSelectedSlot: true,
        alternateRequested: false,
        navigateNext: false,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onAlternateRequested(
    ServiceScheduleAlternateRequested event,
    Emitter<ServiceScheduleState> emit,
  ) {
    emit(
      state.copyWith(
        alternateRequested: true,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onContinuePressed(
    ServiceScheduleContinuePressed event,
    Emitter<ServiceScheduleState> emit,
  ) {
    if (!state.canContinue) {
      emit(
        state.copyWith(
          errorMessage: 'service.schedule.error_select_slot',
          navigateNext: false,
          overrideErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        navigateNext: true,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onNavigationHandled(
    ServiceScheduleNavigationHandled event,
    Emitter<ServiceScheduleState> emit,
  ) {
    if (!state.navigateNext) return;
    emit(state.copyWith(navigateNext: false));
  }

  List<ServiceScheduleDay> _generateMockDays() {
    final now = DateTime.now();
    final List<ServiceScheduleDay> days = [];

    for (int offset = 0; offset < 5; offset++) {
      final date = now.add(Duration(days: offset));
      final isToday = offset == 0;
      final dayLabel = _weekdayLabel(date);
      final dayNumber = date.day.toString();
      final slots = _mockSlotsForOffset(offset);

      days.add(
        ServiceScheduleDay(
          date: date,
          dayLabel: dayLabel,
          dayNumber: dayNumber,
          isToday: isToday,
          slots: slots,
        ),
      );
    }

    return days;
  }

  List<ServiceTimeSlot> _mockSlotsForOffset(int offset) {
    switch (offset) {
      case 0:
        return const [
          ServiceTimeSlot(
            id: 'slot-0-1',
            displayLabel: '10:00 ص',
            isAvailable: false,
          ),
          ServiceTimeSlot(
            id: 'slot-0-2',
            displayLabel: '02:00 م',
            isAvailable: true,
            isRecommended: true,
          ),
          ServiceTimeSlot(
            id: 'slot-0-3',
            displayLabel: '05:00 م',
            isAvailable: true,
          ),
      
        ];
      case 1:
        return const [
          ServiceTimeSlot(
            id: 'slot-1-1',
            displayLabel: '11:00 ص',
            isAvailable: false,
          ),
         
         
          ServiceTimeSlot(
            id: 'slot-1-2',
            displayLabel: '03:00 م',
            isAvailable: true,
          ),
        
          ServiceTimeSlot(
            id: 'slot-1-3',
            displayLabel: '05:00 م',
            isAvailable: true,
          ),
        ];
      default:
        return [
          ServiceTimeSlot(
            id: 'slot-$offset-1',
            displayLabel: '09:00 ص',
            isAvailable: true,
          ),
          ServiceTimeSlot(
            id: 'slot-$offset-2',
            displayLabel: '01:00 م',
            isAvailable: true,
          ),
          ServiceTimeSlot(
            id: 'slot-$offset-3',
            displayLabel: '04:00 م',
            isAvailable: offset % 2 == 0,
          ),
       
        ];
    }
  }

  String _weekdayLabel(DateTime date) {
    switch (date.weekday) {
      case DateTime.sunday:
        return 'service.schedule.weekday_sun';
      case DateTime.monday:
        return 'service.schedule.weekday_mon';
      case DateTime.tuesday:
        return 'service.schedule.weekday_tue';
      case DateTime.wednesday:
        return 'service.schedule.weekday_wed';
      case DateTime.thursday:
        return 'service.schedule.weekday_thu';
      case DateTime.friday:
        return 'service.schedule.weekday_fri';
      case DateTime.saturday:
        return 'service.schedule.weekday_sat';
      default:
        return '';
    }
  }
}
