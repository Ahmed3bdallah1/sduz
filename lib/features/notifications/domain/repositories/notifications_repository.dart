import '../entities/notification_item.dart';

abstract class NotificationsRepository {
  Future<List<NotificationItem>> fetchNotifications();

  Future<void> markAllRead();

  Future<NotificationItem> markAsRead(String notificationId);

  Future<void> deleteNotification(String notificationId);
}
