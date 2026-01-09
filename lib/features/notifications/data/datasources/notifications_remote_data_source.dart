import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_dto.dart';

class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<NotificationDto>> fetchNotifications() async {
    final apiRequest = ApiRequest<List<NotificationDto>>(
      path: AppEndpoints.customer9NotificationsListNotifications.path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseNotificationList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Notifications response is empty');
    }
    return items;
  }

  Future<void> markAllRead() async {
    final apiRequest = ApiRequest<void>(
      path: AppEndpoints.customer9NotificationsMarkAllRead.path,
      method: HttpMethod.post,
      requiresAuth: true,
    );
    await _client.send(apiRequest);
  }

  Future<NotificationDto> markAsRead(String notificationId) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer9NotificationsMarkAsRead.path,
      notificationId,
    );
    final apiRequest = ApiRequest<NotificationDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      parseResponse: _parseNotification,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Mark as read response is empty');
    }
    return dto;
  }

  Future<void> deleteNotification(String notificationId) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer9NotificationsDeleteNotification.path,
      notificationId,
    );
    final apiRequest = ApiRequest<void>(
      path: path,
      method: HttpMethod.delete,
      requiresAuth: true,
    );
    await _client.send(apiRequest);
  }

  NotificationDto _parseNotification(dynamic data) {
    if (data is JsonMap) {
      return NotificationDto.fromJson(data);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['notification'];
      if (nested is JsonMap) {
        return NotificationDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected notification response shape');
  }

  List<NotificationDto> _parseNotificationList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected notifications list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(NotificationDto.fromJson)
        .toList(growable: false);
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['notifications'],
        data['items'],
        data['results'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return null;
  }

  String _replaceIdSegment(String path, String id) {
    final segments = path
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
    final replacementIndex = segments.indexWhere(
      (segment) =>
          segment == '1' ||
          segment == ':id' ||
          segment == '{id}' ||
          segment == ':notification_id',
    );

    if (replacementIndex != -1) {
      segments[replacementIndex] = id;
    } else {
      segments.add(id);
    }

    return '/${segments.join('/')}';
  }
}
