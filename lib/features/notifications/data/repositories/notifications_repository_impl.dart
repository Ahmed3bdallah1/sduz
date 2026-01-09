import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<List<NotificationItem>> fetchNotifications() async {
    final dtos = await _remoteDataSource.fetchNotifications();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<void> markAllRead() {
    return _remoteDataSource.markAllRead();
  }

  @override
  Future<NotificationItem> markAsRead(String notificationId) async {
    final dto = await _remoteDataSource.markAsRead(notificationId);
    return dto.toEntity();
  }

  @override
  Future<void> deleteNotification(String notificationId) {
    return _remoteDataSource.deleteNotification(notificationId);
  }
}
