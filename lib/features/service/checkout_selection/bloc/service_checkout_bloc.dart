import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../address/domain/entities/user_address.dart';
import '../../../car/models/service_car.dart';
import '../../data/models/create_booking_request.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../models/models.dart';
import '../../schedule/models/models.dart';

part 'service_checkout_event.dart';
part 'service_checkout_state.dart';

class ServiceCheckoutBloc
    extends Bloc<ServiceCheckoutEvent, ServiceCheckoutState> {
  ServiceCheckoutBloc({
    required BookingRepository bookingRepository,
    required ServiceType serviceType,
    required ServiceCar car,
    required UserAddress address,
    required ServiceScheduleSelection scheduleSelection,
    ServicePackage? activePackage,
  })  : _bookingRepository = bookingRepository,
        super(ServiceCheckoutState(
          serviceType: serviceType,
          car: car,
          address: address,
          scheduleSelection: scheduleSelection,
          activePackage: activePackage,
        )) {
    on<ServiceCheckoutStarted>(_onStarted);
    on<ServiceCheckoutPaymentMethodChanged>(_onPaymentMethodChanged);
    on<ServiceCheckoutNotesChanged>(_onNotesChanged);
    on<ServiceCheckoutSubmitted>(_onSubmitted);

    add(const ServiceCheckoutStarted());
  }

  final BookingRepository _bookingRepository;

  void _onStarted(
    ServiceCheckoutStarted event,
    Emitter<ServiceCheckoutState> emit,
  ) {
    // Set default payment method to COD
    emit(
      state.copyWith(
        status: ServiceCheckoutStatus.ready,
        selectedPaymentMethod: 'cod',
        overrideSelectedPaymentMethod: true,
      ),
    );
  }

  void _onPaymentMethodChanged(
    ServiceCheckoutPaymentMethodChanged event,
    Emitter<ServiceCheckoutState> emit,
  ) {
    emit(
      state.copyWith(
        selectedPaymentMethod: event.paymentMethod,
        overrideSelectedPaymentMethod: true,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onNotesChanged(
    ServiceCheckoutNotesChanged event,
    Emitter<ServiceCheckoutState> emit,
  ) {
    emit(state.copyWith(notes: event.notes));
  }

  Future<void> _onSubmitted(
    ServiceCheckoutSubmitted event,
    Emitter<ServiceCheckoutState> emit,
  ) async {
    if (state.selectedPaymentMethod == null) {
      emit(
        state.copyWith(
          errorMessage: 'service.checkout.error_select_payment_method',
          overrideErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ServiceCheckoutStatus.processing,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );

    try {
      // Format date and time for API
      final date = state.scheduleSelection.day.date;
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      
      // Parse the time slot display label to extract start and end times
      final slot = state.scheduleSelection.slot;
      final timeInfo = _parseTimeSlot(slot.displayLabel);
      
      final request = CreateBookingRequest(
        serviceId: state.serviceType.id,
        carId: state.car.id,
        addressId: state.address.id,
        scheduledDate: formattedDate,
        scheduledStartTime: timeInfo.startTime,
        scheduledEndTime: timeInfo.endTime,
        paymentMethod: state.selectedPaymentMethod!,
        totalAmount: state.totalAmount,
        notes: state.notes?.trim().isEmpty ?? true ? null : state.notes?.trim(),
      );

      final booking = await _bookingRepository.createBooking(request);

      emit(
        state.copyWith(
          status: ServiceCheckoutStatus.success,
          createdBooking: booking,
          overrideCreatedBooking: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ServiceCheckoutStatus.failure,
          errorMessage: error.toString(),
          overrideErrorMessage: true,
        ),
      );
    }
  }

  ({String startTime, String endTime}) _parseTimeSlot(String displayLabel) {
    // Display label format examples: "10:00 ص" or "02:00 م"
    // Default to 1 hour duration
    final cleanLabel = displayLabel.trim();
    
    // Extract just the time part (remove AM/PM markers)
    final timePart = cleanLabel.replaceAll(RegExp(r'[^\d:]'), '').trim();
    
    // Determine if it's PM
    final isPM = cleanLabel.contains('م') || cleanLabel.toLowerCase().contains('pm');
    
    // Parse hour and minute
    final parts = timePart.split(':');
    if (parts.length != 2) {
      // Fallback
      return (startTime: '10:00', endTime: '11:00');
    }
    
    var hour = int.tryParse(parts[0]) ?? 10;
    final minute = parts[1];
    
    // Convert to 24-hour format
    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }
    
    final startTime = '${hour.toString().padLeft(2, '0')}:$minute';
    
    // Calculate end time (1 hour later)
    var endHour = hour + 1;
    if (endHour >= 24) {
      endHour = endHour - 24;
    }
    
    final endTime = '${endHour.toString().padLeft(2, '0')}:$minute';
    
    return (startTime: startTime, endTime: endTime);
  }
}

