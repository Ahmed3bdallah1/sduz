import 'package:equatable/equatable.dart';

enum TechJobStatus {
  assigned,
  enRoute,
  onSite,
  workStarted,
  workCompleted,
  pendingReview,
  closed,
  rejected,
  cancelled,
}

extension TechJobStatusX on TechJobStatus {
  bool get isTerminal =>
      this == TechJobStatus.closed ||
      this == TechJobStatus.cancelled ||
      this == TechJobStatus.rejected;

  bool get requiresPreWorkEvidence =>
      this == TechJobStatus.workStarted || this == TechJobStatus.workCompleted;

  bool get requiresPostWorkEvidence =>
      this == TechJobStatus.workCompleted ||
      this == TechJobStatus.pendingReview;
}

enum TechJobFilterTag { today, upcoming, overdue, all }

extension TechJobFilterTagX on TechJobFilterTag {
  String get analyticsKey => toString().split('.').last;
}

class TechJob extends Equatable {
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

  const TechJob({
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
    this.preWorkPhotosRequired = 5,
    this.preWorkPhotosUploaded = 0,
    this.postWorkPhotosRequired = 5,
    this.postWorkPhotosUploaded = 0,
    this.hasPendingSync = false,
    this.lastTransitionAt,
  });

  TechJob copyWith({
    String? id,
    String? referenceCode,
    String? serviceSummary,
    String? clientName,
    String? clientPhone,
    String? addressLine,
    double? latitude,
    double? longitude,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    TechJobStatus? status,
    double? distanceKm,
    Duration? eta,
    String? notes,
    int? preWorkPhotosRequired,
    int? preWorkPhotosUploaded,
    int? postWorkPhotosRequired,
    int? postWorkPhotosUploaded,
    bool? hasPendingSync,
    DateTime? lastTransitionAt,
  }) {
    return TechJob(
      id: id ?? this.id,
      referenceCode: referenceCode ?? this.referenceCode,
      serviceSummary: serviceSummary ?? this.serviceSummary,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      addressLine: addressLine ?? this.addressLine,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      status: status ?? this.status,
      distanceKm: distanceKm ?? this.distanceKm,
      eta: eta ?? this.eta,
      notes: notes ?? this.notes,
      preWorkPhotosRequired:
          preWorkPhotosRequired ?? this.preWorkPhotosRequired,
      preWorkPhotosUploaded:
          preWorkPhotosUploaded ?? this.preWorkPhotosUploaded,
      postWorkPhotosRequired:
          postWorkPhotosRequired ?? this.postWorkPhotosRequired,
      postWorkPhotosUploaded:
          postWorkPhotosUploaded ?? this.postWorkPhotosUploaded,
      hasPendingSync: hasPendingSync ?? this.hasPendingSync,
      lastTransitionAt: lastTransitionAt ?? this.lastTransitionAt,
    );
  }

  bool get isPreWorkComplete => preWorkPhotosUploaded >= preWorkPhotosRequired;

  bool get isPostWorkComplete =>
      postWorkPhotosUploaded >= postWorkPhotosRequired;

  bool get isOverdue {
    if (isTerminal) return false;
    final now = DateTime.now();
    final windowEnd = scheduledEnd ?? scheduledStart;
    return now.isAfter(windowEnd);
  }

  bool get isToday {
    final now = DateTime.now();
    return scheduledStart.year == now.year &&
        scheduledStart.month == now.month &&
        scheduledStart.day == now.day;
  }

  bool get isUpcoming {
    final now = DateTime.now();
    return scheduledStart.isAfter(now) && !isOverdue && !isToday;
  }

  bool get isTerminal => status.isTerminal;

  @override
  List<Object?> get props => [
    id,
    referenceCode,
    serviceSummary,
    clientName,
    clientPhone,
    addressLine,
    latitude,
    longitude,
    scheduledStart,
    scheduledEnd,
    status,
    distanceKm,
    eta,
    notes,
    preWorkPhotosRequired,
    preWorkPhotosUploaded,
    postWorkPhotosRequired,
    postWorkPhotosUploaded,
    hasPendingSync,
    lastTransitionAt,
  ];
}
