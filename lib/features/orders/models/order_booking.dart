import 'package:equatable/equatable.dart';
import 'package:sudz/features/service/domain/entities/booking.dart';

class OrderBooking extends Equatable {
  final String id;
  final DateTime scheduledAt;
  final String serviceName;
  final String status;
  final String? address;
  final String? notes;
  final double? totalAmount;

  const OrderBooking({
    required this.id,
    required this.scheduledAt,
    required this.serviceName,
    required this.status,
    this.address,
    this.notes,
    this.totalAmount,
  });

  factory OrderBooking.fromBooking(Booking booking) {
    return OrderBooking(
      id: booking.id,
      scheduledAt: _mergeDateTime(
        booking.scheduledDate,
        booking.scheduledStartTime,
      ),
      serviceName: booking.serviceName ?? 'الخدمة',
      status: booking.status,
      address: booking.addressDetails,
      notes: booking.notes,
      totalAmount: booking.totalAmount,
    );
  }

  static DateTime _mergeDateTime(String date, String time) {
    final combined = DateTime.tryParse('$date $time');
    if (combined != null) return combined;
    final dateOnly = DateTime.tryParse(date);
    if (dateOnly != null) return dateOnly;
    return DateTime.now();
  }

  @override
  List<Object?> get props => [
        id,
        scheduledAt,
        serviceName,
        status,
        address,
        notes,
        totalAmount,
      ];
}
