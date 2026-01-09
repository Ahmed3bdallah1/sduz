import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersStarted extends OrdersEvent {
  const OrdersStarted();
}

class OrdersSegmentChanged extends OrdersEvent {
  final OrdersSegment segment;

  const OrdersSegmentChanged(this.segment);

  @override
  List<Object?> get props => [segment];
}

enum OrdersSegment { upcoming, previous, cancelled }

extension OrdersSegmentX on OrdersSegment {
  String get label {
    switch (this) {
      case OrdersSegment.upcoming:
        return 'القادم';
      case OrdersSegment.previous:
        return 'السابق';
      case OrdersSegment.cancelled:
        return 'الملغي';
    }
  }
}
