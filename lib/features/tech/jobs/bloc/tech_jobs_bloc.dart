import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/tech/jobs/models/models.dart';

import '../domain/repositories/tech_jobs_repository.dart';
import 'tech_jobs_event.dart';
import 'tech_jobs_state.dart';

class TechJobsBloc extends Bloc<TechJobsEvent, TechJobsState> {
  TechJobsBloc({required TechJobsRepository repository})
      : _repository = repository,
        super(const TechJobsState()) {
    on<TechJobsStarted>(_onStarted);
    on<TechJobsFilterChanged>(_onFilterChanged);
    on<TechJobsRefreshed>(_onRefreshed);
  }

  final TechJobsRepository _repository;

  Future<void> _onStarted(
    TechJobsStarted event,
    Emitter<TechJobsState> emit,
  ) async {
    emit(state.copyWith(status: TechJobsStatus.loading));
    await _loadJobs(emit, state.filter);
  }

  Future<void> _onRefreshed(
    TechJobsRefreshed event,
    Emitter<TechJobsState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    await _loadJobs(emit, state.filter);
    emit(state.copyWith(isSyncing: false));
  }

  void _onFilterChanged(
    TechJobsFilterChanged event,
    Emitter<TechJobsState> emit,
  ) {
    if (event.filter == state.filter) return;
    emit(state.copyWith(filter: event.filter));
    _loadJobs(emit, event.filter);
  }

  Future<void> _loadJobs(
    Emitter<TechJobsState> emit,
    TechJobFilterTag filter,
  ) async {
    try {
      final filterValue = _filterParam(filter);
      final jobs = await _repository.fetchJobs(filter: filterValue);
      emit(
        state.copyWith(
          status: TechJobsStatus.success,
          jobs: jobs,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: TechJobsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  String? _filterParam(TechJobFilterTag filter) {
    switch (filter) {
      case TechJobFilterTag.today:
        return 'today';
      case TechJobFilterTag.upcoming:
        return 'available';
      case TechJobFilterTag.overdue:
        return 'in_progress';
      case TechJobFilterTag.all:
        return null;
    }
  }
}
