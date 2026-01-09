import 'package:equatable/equatable.dart';

import '../models/models.dart';

abstract class TechJobDetailsEvent extends Equatable {
  const TechJobDetailsEvent();

  @override
  List<Object?> get props => [];
}

class TechJobDetailsStarted extends TechJobDetailsEvent {
  final TechJob job;

  const TechJobDetailsStarted(this.job);

  @override
  List<Object?> get props => [job];
}

class TechJobArriveRequested extends TechJobDetailsEvent {
  const TechJobArriveRequested();
}

class TechJobArriveOverrideProvided extends TechJobDetailsEvent {
  final String note;

  const TechJobArriveOverrideProvided(this.note);

  @override
  List<Object?> get props => [note];
}

class TechJobGeoWarningDismissed extends TechJobDetailsEvent {
  const TechJobGeoWarningDismissed();
}

class TechJobPreEvidenceAdded extends TechJobDetailsEvent {
  const TechJobPreEvidenceAdded();
}

class TechJobPostEvidenceAdded extends TechJobDetailsEvent {
  const TechJobPostEvidenceAdded();
}

class TechJobRejectionEvidenceAdded extends TechJobDetailsEvent {
  const TechJobRejectionEvidenceAdded();
}

class TechJobEvidenceRemoved extends TechJobDetailsEvent {
  final String evidenceId;

  const TechJobEvidenceRemoved(this.evidenceId);

  @override
  List<Object?> get props => [evidenceId];
}

class TechJobStartWorkRequested extends TechJobDetailsEvent {
  const TechJobStartWorkRequested();
}

class TechJobCompleteRequested extends TechJobDetailsEvent {
  const TechJobCompleteRequested();
}

class TechJobRejectRequested extends TechJobDetailsEvent {
  final String reason;

  const TechJobRejectRequested(this.reason);

  @override
  List<Object?> get props => [reason];
}

class TechJobToastCleared extends TechJobDetailsEvent {
  const TechJobToastCleared();
}

class TechJobSyncPendingRequested extends TechJobDetailsEvent {
  const TechJobSyncPendingRequested();
}
