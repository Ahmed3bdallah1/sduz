import 'package:sudz/core/models/json_types.dart';
import '../../models/tech_job.dart';

class TechJobDto {
  const TechJobDto({
    required this.id,
    required this.referenceCode,
    required this.serviceSummary,
    required this.clientName,
    required this.clientPhone,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    required this.scheduledStart,
    this.scheduledEnd,
    this.status = TechJobStatus.assigned,
    this.distanceKm,
    this.eta,
    this.notes,
    this.preWorkPhotosRequired = 0,
    this.preWorkPhotosUploaded = 0,
    this.postWorkPhotosRequired = 0,
    this.postWorkPhotosUploaded = 0,
    this.hasPendingSync = false,
    this.lastTransitionAt,
  });

  final String id;
  final String referenceCode;
  final String serviceSummary;
  final String clientName;
  final String clientPhone;
  final String addressLine;
  final double latitude;
  final double longitude;
  final DateTime scheduledStart;
  final DateTime? scheduledEnd;
  final TechJobStatus status;
  final double? distanceKm;
  final Duration? eta;
  final String? notes;
  final int preWorkPhotosRequired;
  final int preWorkPhotosUploaded;
  final int postWorkPhotosRequired;
  final int postWorkPhotosUploaded;
  final bool hasPendingSync;
  final DateTime? lastTransitionAt;

  factory TechJobDto.fromJson(JsonMap json) {
    final statusString = _stringify(json['status']) ?? '';
    return TechJobDto(
      id: _stringify(json['id'] ?? json['uuid']) ?? '',
      referenceCode: _stringify(json['reference_code'] ?? json['code']) ?? '',
      serviceSummary:
          _stringify(json['service_summary'] ?? json['service'] ?? '') ?? '',
      clientName: _stringify(json['client_name'] ?? json['customer_name']) ?? '',
      clientPhone:
          _stringify(json['client_phone'] ?? json['customer_phone'] ?? '') ?? '',
      addressLine: _stringify(json['address'] ?? json['address_line'] ?? '') ??
          '',
      latitude: _toDouble(json['latitude'] ?? json['lat']) ?? 0,
      longitude: _toDouble(json['longitude'] ?? json['lng'] ?? json['lon']) ?? 0,
      scheduledStart: _toDate(json['scheduled_start'] ?? json['start_time']) ??
          DateTime.now(),
      scheduledEnd: _toDate(json['scheduled_end'] ?? json['end_time']),
      status: _parseStatus(statusString),
      distanceKm: _toDouble(json['distance_km'] ?? json['distance']),
      eta: _toDuration(json['eta_minutes'] ?? json['eta']),
      notes: _stringify(json['notes']),
      preWorkPhotosRequired:
          _toInt(json['pre_work_photos_required'] ?? json['pre_photos_required']) ??
              0,
      preWorkPhotosUploaded:
          _toInt(json['pre_work_photos_uploaded'] ?? json['pre_photos_uploaded']) ??
              0,
      postWorkPhotosRequired: _toInt(
            json['post_work_photos_required'] ?? json['post_photos_required'],
          ) ??
          0,
      postWorkPhotosUploaded: _toInt(
            json['post_work_photos_uploaded'] ?? json['post_photos_uploaded'],
          ) ??
          0,
      hasPendingSync: _toBool(json['has_pending_sync'] ?? json['pending_sync']) ??
          false,
      lastTransitionAt: _toDate(json['last_transition_at']),
    );
  }

  TechJob toEntity() {
    return TechJob(
      id: id,
      referenceCode: referenceCode,
      serviceSummary: serviceSummary,
      clientName: clientName,
      clientPhone: clientPhone,
      addressLine: addressLine,
      latitude: latitude,
      longitude: longitude,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      status: status,
      distanceKm: distanceKm,
      eta: eta,
      notes: notes,
      preWorkPhotosRequired: preWorkPhotosRequired,
      preWorkPhotosUploaded: preWorkPhotosUploaded,
      postWorkPhotosRequired: postWorkPhotosRequired,
      postWorkPhotosUploaded: postWorkPhotosUploaded,
      hasPendingSync: hasPendingSync,
      lastTransitionAt: lastTransitionAt,
    );
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.trim().isEmpty ? null : value.trim();
    return value.toString();
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value.trim());
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

  static Duration? _toDuration(dynamic value) {
    final minutes = _toInt(value);
    if (minutes == null) return null;
    return Duration(minutes: minutes);
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == 'yes' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == 'no' || normalized == '0') {
        return false;
      }
    }
    return null;
  }

  static TechJobStatus _parseStatus(String value) {
    switch (value.toLowerCase()) {
      case 'assigned':
        return TechJobStatus.assigned;
      case 'en_route':
      case 'enroute':
      case 'en route':
        return TechJobStatus.enRoute;
      case 'on_site':
      case 'onsite':
        return TechJobStatus.onSite;
      case 'work_started':
      case 'started':
        return TechJobStatus.workStarted;
      case 'work_completed':
      case 'completed':
        return TechJobStatus.workCompleted;
      case 'pending_review':
      case 'review':
        return TechJobStatus.pendingReview;
      case 'closed':
        return TechJobStatus.closed;
      case 'rejected':
        return TechJobStatus.rejected;
      case 'cancelled':
      case 'canceled':
        return TechJobStatus.cancelled;
      default:
        return TechJobStatus.assigned;
    }
  }
}
