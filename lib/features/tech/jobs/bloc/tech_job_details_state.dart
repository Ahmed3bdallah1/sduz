import 'package:equatable/equatable.dart';

import '../models/models.dart';

enum TechJobDetailsStatus { initial, loading, ready, failure }

extension TechJobDetailsStatusX on TechJobDetailsStatus {
  bool get isInitial => this == TechJobDetailsStatus.initial;
  bool get isLoading => this == TechJobDetailsStatus.loading;
  bool get isReady => this == TechJobDetailsStatus.ready;
  bool get isFailure => this == TechJobDetailsStatus.failure;
}

class TechJobDetailsState extends Equatable {
  static const _sentinel = Object();
  final TechJobDetailsStatus status;
  final TechJob job;
  final List<TechJobEvidenceItem> evidence;
  final List<TechJobTimelineEntry> timeline;
  final List<TechJobPendingAction> pendingActions;
  final TechJobActionKind? activeAction;
  final bool isActionInProgress;
  final bool isSyncing;
  final bool geoWarningActive;
  final double? geoDistanceMeters;
  final String? toastKey;
  final List<String>? toastArgs;
  final String? errorMessage;

  const TechJobDetailsState({
    this.status = TechJobDetailsStatus.initial,
    required this.job,
    this.evidence = const [],
    this.timeline = const [],
    this.pendingActions = const [],
    this.activeAction,
    this.isActionInProgress = false,
    this.isSyncing = false,
    this.geoWarningActive = false,
    this.geoDistanceMeters,
    this.toastKey,
    this.toastArgs,
    this.errorMessage,
  });

  TechJobDetailsState copyWith({
    TechJobDetailsStatus? status,
    TechJob? job,
    List<TechJobEvidenceItem>? evidence,
    List<TechJobTimelineEntry>? timeline,
    List<TechJobPendingAction>? pendingActions,
    TechJobActionKind? activeAction,
    bool? isActionInProgress,
    bool? isSyncing,
    bool? geoWarningActive,
    double? geoDistanceMeters,
    Object? toastKey = _sentinel,
    Object? toastArgs = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return TechJobDetailsState(
      status: status ?? this.status,
      job: job ?? this.job,
      evidence: evidence ?? this.evidence,
      timeline: timeline ?? this.timeline,
      pendingActions: pendingActions ?? this.pendingActions,
      activeAction: activeAction ?? this.activeAction,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
      isSyncing: isSyncing ?? this.isSyncing,
      geoWarningActive: geoWarningActive ?? this.geoWarningActive,
      geoDistanceMeters: geoDistanceMeters ?? this.geoDistanceMeters,
      toastKey: toastKey == _sentinel ? this.toastKey : toastKey as String?,
      toastArgs: toastArgs == _sentinel
          ? this.toastArgs
          : toastArgs as List<String>?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  List<TechJobEvidenceItem> get preEvidence =>
      evidence.where((item) => item.category.isPre).toList();

  List<TechJobEvidenceItem> get postEvidence =>
      evidence.where((item) => item.category.isPost).toList();

  List<TechJobEvidenceItem> get rejectionEvidence =>
      evidence.where((item) => item.category.isRejection).toList();

  int get preEvidenceCount => preEvidence.length;
  int get postEvidenceCount => postEvidence.length;

  bool get hasEnoughPreEvidence =>
      preEvidenceCount >= job.preWorkPhotosRequired;

  bool get hasEnoughPostEvidence =>
      postEvidenceCount >= job.postWorkPhotosRequired;

  bool get isTerminal => job.status.isTerminal;

  bool get canArrive =>
      !isTerminal &&
      !isActionInProgress &&
      (job.status == TechJobStatus.assigned ||
          job.status == TechJobStatus.enRoute);

  bool get canStartWork =>
      !isTerminal &&
      !isActionInProgress &&
      job.status == TechJobStatus.onSite &&
      hasEnoughPreEvidence;

  bool get canCompleteWork =>
      !isTerminal &&
      !isActionInProgress &&
      job.status == TechJobStatus.workStarted &&
      hasEnoughPostEvidence;

  bool get canReject =>
      !isTerminal &&
      !isActionInProgress &&
      (job.status == TechJobStatus.assigned ||
          job.status == TechJobStatus.onSite);

  bool get hasPendingActions => pendingActions.isNotEmpty;

  bool get hasPendingSync => hasPendingActions || job.hasPendingSync;

  @override
  List<Object?> get props => [
    status,
    job,
    evidence,
    timeline,
    pendingActions,
    activeAction,
    isActionInProgress,
    isSyncing,
    geoWarningActive,
    geoDistanceMeters,
    toastKey,
    toastArgs,
    errorMessage,
  ];
}
