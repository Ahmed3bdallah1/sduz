import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/orders/models/models.dart';
import 'package:sudz/features/service/domain/entities/booking.dart';
import 'package:sudz/features/service/domain/repositories/booking_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required BookingRepository bookingRepository})
      : _bookingRepository = bookingRepository,
        super(const OrdersState()) {
    on<OrdersStarted>(_onStarted);
    on<OrdersSegmentChanged>(_onSegmentChanged);
  }

  final BookingRepository _bookingRepository;

  Future<void> _onStarted(
    OrdersStarted event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));

    try {
      final bookings = await _bookingRepository.fetchBookings();
      final categorized = _categorize(bookings);
      emit(
        state.copyWith(
          status: OrdersStatus.success,
          upcoming: categorized.upcoming,
          previous: categorized.previous,
          cancelled: categorized.cancelled,
          segment: state.segment,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onSegmentChanged(
    OrdersSegmentChanged event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(segment: event.segment));
  }

  _CategorizedOrders _categorize(List<Booking> bookings) {
    final upcoming = <OrderBooking>[];
    final previous = <OrderBooking>[];
    final cancelled = <OrderBooking>[];

    for (final booking in bookings) {
      final status = booking.status.toLowerCase();
      final mapped = OrderBooking.fromBooking(booking);
      if (status.contains('cancel')) {
        cancelled.add(mapped);
      } else if (status.contains('complete') || status.contains('done')) {
        previous.add(mapped);
      } else {
        upcoming.add(mapped);
      }
    }

    return _CategorizedOrders(
      upcoming: upcoming,
      previous: previous,
      cancelled: cancelled,
    );
  }
}

class _CategorizedOrders {
  const _CategorizedOrders({
    required this.upcoming,
    required this.previous,
    required this.cancelled,
  });

  final List<OrderBooking> upcoming;
  final List<OrderBooking> previous;
  final List<OrderBooking> cancelled;
}
