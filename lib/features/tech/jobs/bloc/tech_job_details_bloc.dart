import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../domain/repositories/tech_jobs_repository.dart';
import '../models/models.dart';
import 'tech_job_details_event.dart';
import 'tech_job_details_state.dart';

class TechJobDetailsBloc
    extends Bloc<TechJobDetailsEvent, TechJobDetailsState> {
  TechJobDetailsBloc({
    required TechJob job,
    required TechJobsRepository repository,
  })  : _repository = repository,
        super(TechJobDetailsState(job: job)) {
    on<TechJobDetailsStarted>(_onStarted);
    on<TechJobArriveRequested>(_onArriveRequested);
    on<TechJobArriveOverrideProvided>(_onArriveOverrideProvided);
    on<TechJobGeoWarningDismissed>(_onGeoWarningDismissed);
    on<TechJobPreEvidenceAdded>(_onPreEvidenceAdded);
    on<TechJobPostEvidenceAdded>(_onPostEvidenceAdded);
    on<TechJobRejectionEvidenceAdded>(_onRejectionEvidenceAdded);
    on<TechJobEvidenceRemoved>(_onEvidenceRemoved);
    on<TechJobStartWorkRequested>(_onStartWorkRequested);
    on<TechJobCompleteRequested>(_onCompleteRequested);
    on<TechJobRejectRequested>(_onRejectRequested);
    on<TechJobToastCleared>(_onToastCleared);
    on<TechJobSyncPendingRequested>(_onSyncPendingRequested);
  }

  final TechJobsRepository _repository;

  FutureOr<void> _onStarted(
    TechJobDetailsStarted event,
    Emitter<TechJobDetailsState> emit,
  ) {
    final seededEvidence = <TechJobEvidenceItem>[
      ..._seedEvidence(
        event.job.preWorkPhotosUploaded,
        TechJobEvidenceCategory.preWork,
      ),
      ..._seedEvidence(
        event.job.postWorkPhotosUploaded,
        TechJobEvidenceCategory.postWork,
      ),
    ];

    final seededTimeline = _seedTimeline(event.job);

    emit(
      state.copyWith(
        status: TechJobDetailsStatus.ready,
        job: event.job,
        evidence: seededEvidence,
        timeline: seededTimeline as List<TechJobTimelineEntry>,
      ),
    );
  }

  FutureOr<void> _onArriveRequested(
    TechJobArriveRequested event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    if (!state.canArrive) {
      emit(
        state.copyWith(
          toastKey: state.isTerminal
              ? 'tech.jobs.details.toast.already_closed'
              : 'tech.jobs.details.toast.arrive_invalid_state',
          toastArgs: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        activeAction: TechJobActionKind.arrive,
        isActionInProgress: true,
        toastKey: null,
        toastArgs: null,
      ),
    );

    try {
      final updated = await _repository.arriveJob(state.job.id);
      emit(
        state.copyWith(
          job: updated,
          activeAction: null,
          isActionInProgress: false,
          toastKey: 'tech.jobs.details.toast.arrived',
          toastArgs: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          activeAction: null,
          isActionInProgress: false,
          toastKey: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onArriveOverrideProvided(
    TechJobArriveOverrideProvided event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    if (!state.geoWarningActive) return;
    emit(state.copyWith(geoWarningActive: false));
  }

  FutureOr<void> _onGeoWarningDismissed(
    TechJobGeoWarningDismissed event,
    Emitter<TechJobDetailsState> emit,
  ) {
    emit(
      state.copyWith(
        geoWarningActive: false,
        geoDistanceMeters: null,
        activeAction: null,
        isActionInProgress: false,
      ),
    );
  }

  FutureOr<void> _onPreEvidenceAdded(
    TechJobPreEvidenceAdded event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        toastKey: 'tech.jobs.details.toast.pre_evidence_progress',
        toastArgs: [
          (state.preEvidenceCount + 1).toString(),
          state.job.preWorkPhotosRequired.toString(),
        ],
      ),
    );
  }

  FutureOr<void> _onPostEvidenceAdded(
    TechJobPostEvidenceAdded event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        toastKey: 'tech.jobs.details.toast.post_evidence_progress',
        toastArgs: [
          (state.postEvidenceCount + 1).toString(),
          state.job.postWorkPhotosRequired.toString(),
        ],
      ),
    );
  }

  FutureOr<void> _onRejectionEvidenceAdded(
    TechJobRejectionEvidenceAdded event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    final newEvidence = List<TechJobEvidenceItem>.from(state.evidence)
      ..add(
        _generateEvidenceItem(
          TechJobEvidenceCategory.rejection,
          index: state.rejectionEvidence.length + 1,
        ),
      );

    emit(
      state.copyWith(
        evidence: newEvidence,
        toastKey: 'tech.jobs.details.toast.rejection_evidence_added',
        toastArgs: [(state.rejectionEvidence.length + 1).toString()],
      ),
    );
  }

  FutureOr<void> _onEvidenceRemoved(
    TechJobEvidenceRemoved event,
    Emitter<TechJobDetailsState> emit,
  ) {
    final updatedEvidence =
        state.evidence.where((item) => item.id != event.evidenceId).toList();
    emit(state.copyWith(evidence: updatedEvidence));
  }

  FutureOr<void> _onStartWorkRequested(
    TechJobStartWorkRequested event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        activeAction: TechJobActionKind.startWork,
        isActionInProgress: true,
        toastKey: null,
        toastArgs: null,
      ),
    );

    try {
      final updated = await _repository.startJob(state.job.id);
      emit(
        state.copyWith(
          job: updated,
          activeAction: null,
          isActionInProgress: false,
          toastKey: 'tech.jobs.details.toast.work_started',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          activeAction: null,
          isActionInProgress: false,
          toastKey: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onCompleteRequested(
    TechJobCompleteRequested event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        activeAction: TechJobActionKind.completeWork,
        isActionInProgress: true,
        toastKey: null,
        toastArgs: null,
      ),
    );

    try {
      final updated = await _repository.completeJob(state.job.id);
      emit(
        state.copyWith(
          job: updated,
          activeAction: null,
          isActionInProgress: false,
          toastKey: 'tech.jobs.details.toast.work_completed',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          activeAction: null,
          isActionInProgress: false,
          toastKey: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onRejectRequested(
    TechJobRejectRequested event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        activeAction: TechJobActionKind.reject,
        isActionInProgress: true,
        toastKey: null,
        toastArgs: null,
      ),
    );

    try {
      final updated = await _repository.rejectJob(state.job.id, reason: event.reason);
      emit(
        state.copyWith(
          job: updated,
          activeAction: null,
          isActionInProgress: false,
          toastKey: 'tech.jobs.details.toast.rejected',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          activeAction: null,
          isActionInProgress: false,
          toastKey: error.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onToastCleared(
    TechJobToastCleared event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    emit(state.copyWith(toastKey: null, toastArgs: null));
  }

  FutureOr<void> _onSyncPendingRequested(
    TechJobSyncPendingRequested event,
    Emitter<TechJobDetailsState> emit,
  ) async {
    if (!state.job.hasPendingSync) return;
    emit(state.copyWith(isActionInProgress: true));
    await Future<void>.delayed(const Duration(milliseconds: 600));

    emit(
      state.copyWith(
        job: state.job.copyWith(hasPendingSync: false),
        isActionInProgress: false,
      ),
    );
  }

  List<TechJobEvidenceItem> _seedEvidence(
    int count,
    TechJobEvidenceCategory category,
  ) {
    return List<TechJobEvidenceItem>.generate(
      count,
      (index) => _generateEvidenceItem(category, index: index + 1),
    );
  }

  List<TechJobEvidenceItem> _seedTimeline(TechJob job) {
    final formatter = DateFormat('hh:mm a');
    final items = <TechJobEvidenceItem>[];
    items.add(
      TechJobEvidenceItem(
        id: 'timeline-${job.id}-assigned',
        category: TechJobEvidenceCategory.preWork,
        label: 'tech.jobs.details.timeline.assigned',
        createdAt: job.scheduledStart,
      ),
    );
    if (job.lastTransitionAt != null) {
      items.add(
        TechJobEvidenceItem(
          id: 'timeline-${job.id}-status',
          category: TechJobEvidenceCategory.preWork,
          label: job.status.name,
          createdAt: job.lastTransitionAt!,
        ),
      );
    }
    return items;
  }

  TechJobEvidenceItem _generateEvidenceItem(
    TechJobEvidenceCategory category, {
    required int index,
  }) {
    return TechJobEvidenceItem(
      id: '${category.name}-$index-${DateTime.now().microsecondsSinceEpoch}',
      category: category,
      label: '${category.name} evidence #$index',
      createdAt: DateTime.now(),
    );
  }
}
