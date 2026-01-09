import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/profile/dedication/bloc/dedication_event.dart';
import 'package:sudz/features/profile/dedication/bloc/dedication_state.dart';
import 'package:sudz/features/profile/dedication/data/dedication_repository.dart';

class DedicationBloc extends Bloc<DedicationEvent, DedicationState> {
  final DedicationRepository _repository;

  DedicationBloc({DedicationRepository? repository})
      : _repository = repository ?? const DedicationRepository(),
        super(const DedicationState()) {
    on<DedicationStarted>(_onStarted);
    on<DedicationPhoneChanged>(_onPhoneChanged);
    on<DedicationTypeSelected>(_onTypeSelected);
    on<DedicationSubmitted>(_onSubmitted);
    on<DedicationFeedbackCleared>(_onFeedbackCleared);
  }

  Future<void> _onStarted(
    DedicationStarted event,
    Emitter<DedicationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: DedicationStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final types = await _repository.fetchDedicationTypes();
      emit(
        state.copyWith(
          status: DedicationStatus.ready,
          types: types,
          selectedTypeId: types.isNotEmpty ? types.first.id : null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DedicationStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onPhoneChanged(
    DedicationPhoneChanged event,
    Emitter<DedicationState> emit,
  ) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        errorMessage: null,
        status: state.status.isFailure ? DedicationStatus.ready : null,
      ),
    );
  }

  void _onTypeSelected(
    DedicationTypeSelected event,
    Emitter<DedicationState> emit,
  ) {
    if (state.types.any((type) => type.id == event.typeId)) {
      emit(
        state.copyWith(
          selectedTypeId: event.typeId,
          errorMessage: null,
          status: state.status.isFailure ? DedicationStatus.ready : null,
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    DedicationSubmitted event,
    Emitter<DedicationState> emit,
  ) async {
    final phone = state.phoneNumber.trim();
    final selectedType = state.selectedType;

    if (phone.isEmpty) {
      emit(
        state.copyWith(
          status: DedicationStatus.failure,
          errorMessage: 'profile.dedication.error_phone',
        ),
      );
      return;
    }

    if (selectedType == null) {
      emit(
        state.copyWith(
          status: DedicationStatus.failure,
          errorMessage: 'profile.dedication.error_type',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: DedicationStatus.submitting,
        errorMessage: null,
      ),
    );

    try {
      await _repository.submitDedication(
        phoneNumber: phone,
        type: selectedType,
      );

      emit(
        state.copyWith(
          status: DedicationStatus.success,
          phoneNumber: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DedicationStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onFeedbackCleared(
    DedicationFeedbackCleared event,
    Emitter<DedicationState> emit,
  ) {
    if (state.status.isSuccess || state.status.isFailure) {
      emit(
        state.copyWith(
          status: DedicationStatus.ready,
          errorMessage: null,
        ),
      );
    }
  }
}
