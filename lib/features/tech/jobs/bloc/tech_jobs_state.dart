import 'package:equatable/equatable.dart';
import 'package:sudz/features/tech/jobs/models/models.dart';

enum TechJobsStatus { initial, loading, success, failure }

extension TechJobsStatusX on TechJobsStatus {
  bool get isInitial => this == TechJobsStatus.initial;
  bool get isLoading => this == TechJobsStatus.loading;
  bool get isSuccess => this == TechJobsStatus.success;
  bool get isFailure => this == TechJobsStatus.failure;
}

class TechJobsState extends Equatable {
  final TechJobsStatus status;
  final List<TechJob> jobs;
  final TechJobFilterTag filter;
  final bool isSyncing;
  final String? errorMessage;

  const TechJobsState({
    this.status = TechJobsStatus.initial,
    this.jobs = const [],
    this.filter = TechJobFilterTag.today,
    this.errorMessage,
    this.isSyncing = false,
  });

  TechJobsState copyWith({
    TechJobsStatus? status,
    List<TechJob>? jobs,
    TechJobFilterTag? filter,
    String? errorMessage,
    bool? isSyncing,
  }) {
    return TechJobsState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  List<TechJob> get visibleJobs {
    final List<TechJob> filtered;

    switch (filter) {
      case TechJobFilterTag.today:
        filtered = jobs.where((job) => job.isToday).toList();
      case TechJobFilterTag.upcoming:
        filtered = jobs.where((job) => job.isUpcoming).toList();
      case TechJobFilterTag.overdue:
        filtered = jobs.where((job) => job.isOverdue).toList();
      case TechJobFilterTag.all:
        filtered = List<TechJob>.from(jobs);
    }

    filtered.sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));
    return filtered;
  }

  bool get hasError => status.isFailure && errorMessage != null;

  @override
  List<Object?> get props => [status, jobs, filter, isSyncing, errorMessage];
}
