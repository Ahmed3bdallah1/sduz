import '../../../../core/models/json_types.dart';
import '../../domain/entities/booking_timeline_entry.dart';

class BookingTimelineEntryDto {
  const BookingTimelineEntryDto({
    required this.status,
    this.message,
    this.timestamp,
  });

  final String status;
  final String? message;
  final DateTime? timestamp;

  factory BookingTimelineEntryDto.fromJson(JsonMap json) {
    return BookingTimelineEntryDto(
      status: _stringify(
            json['status'] ?? json['title'] ?? json['state'],
          ) ??
          '',
      message: _stringify(
        json['message'] ?? json['description'] ?? json['note'],
      ),
      timestamp: _toDate(
        json['timestamp'] ??
            json['created_at'] ??
            json['updated_at'] ??
            json['time'],
      ),
    );
  }

  BookingTimelineEntry toEntity() {
    return BookingTimelineEntry(
      status: status,
      message: message,
      timestamp: timestamp,
    );
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim().isEmpty ? null : value.trim();
    }
    return value.toString();
  }

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }
}
