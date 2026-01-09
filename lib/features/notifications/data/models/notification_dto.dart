import '../../../../core/models/json_types.dart';
import '../../domain/entities/notification_item.dart';

class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;

  factory NotificationDto.fromJson(JsonMap json) {
    return NotificationDto(
      id: _stringify(json['id'] ?? json['uuid']) ?? '',
      title: _stringify(json['title'] ?? json['subject']) ?? '',
      body: _stringify(json['body'] ?? json['message'] ?? json['description']) ??
          '',
      isRead: _toBool(json['is_read'] ?? json['read'] ?? json['seen']) ?? false,
      createdAt: _toDate(json['created_at']),
    );
  }

  NotificationItem toEntity() {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim().isEmpty ? null : value.trim();
    }
    return value.toString();
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }
}
