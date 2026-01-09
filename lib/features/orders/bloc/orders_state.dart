import 'package:equatable/equatable.dart';
import 'package:sudz/features/orders/bloc/orders_event.dart';
import 'package:sudz/features/orders/models/models.dart';

enum OrdersStatus { initial, loading, success, failure }

extension OrdersStatusX on OrdersStatus {
  bool get isInitial => this == OrdersStatus.initial;
  bool get isLoading => this == OrdersStatus.loading;
  bool get isSuccess => this == OrdersStatus.success;
  bool get isFailure => this == OrdersStatus.failure;
}

class OrdersState extends Equatable {
  final OrdersStatus status;
  final OrdersSegment segment;
  final List<OrderBooking> upcoming;
  final List<OrderBooking> previous;
  final List<OrderBooking> cancelled;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.segment = OrdersSegment.upcoming,
    this.upcoming = const [],
    this.previous = const [],
    this.cancelled = const [],
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    OrdersSegment? segment,
    List<OrderBooking>? upcoming,
    List<OrderBooking>? previous,
    List<OrderBooking>? cancelled,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      segment: segment ?? this.segment,
      upcoming: upcoming ?? this.upcoming,
      previous: previous ?? this.previous,
      cancelled: cancelled ?? this.cancelled,
      errorMessage: errorMessage,
    );
  }

  List<OrderBooking> get currentOrders {
    switch (segment) {
      case OrdersSegment.upcoming:
        return upcoming;
      case OrdersSegment.previous:
        return previous;
      case OrdersSegment.cancelled:
        return cancelled;
    }
  }

  @override
  List<Object?> get props => [
        status,
        segment,
        upcoming,
        previous,
        cancelled,
        errorMessage,
      ];
}
