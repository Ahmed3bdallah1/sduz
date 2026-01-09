import 'package:equatable/equatable.dart';

class BookingTimelineEntry extends Equatable {
  const BookingTimelineEntry({
    required this.status,
    this.message,
    this.timestamp,
  });

  final String status;
  final String? message;
  final DateTime? timestamp;

  @override
  List<Object?> get props => [status, message, timestamp];
}
