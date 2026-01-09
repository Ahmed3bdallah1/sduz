import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/car/data/models/car_payload.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/features/car/domain/repositories/car_repository.dart';

import 'add_car_event.dart';
import 'add_car_state.dart';

class AddCarBloc extends Bloc<AddCarEvent, AddCarState> {
  AddCarBloc({required CarRepository carRepository})
    : _repository = carRepository,
      super(const AddCarState()) {
    on<AddCarStarted>(_onStarted);
    on<AddCarNameChanged>(_onNameChanged);
    on<AddCarBrandChanged>(_onBrandChanged);
    on<AddCarModelChanged>(_onModelChanged);
    on<AddCarYearChanged>(_onYearChanged);
    on<AddCarColorChanged>(_onColorChanged);
    on<AddCarPlateChanged>(_onPlateChanged);
    on<AddCarSizeChanged>(_onSizeChanged);
    on<AddCarPrimaryToggled>(_onPrimaryToggled);
    on<AddCarImageChanged>(_onImageChanged);
    on<AddCarSubmitted>(_onSubmitted);
  }

  final CarRepository _repository;
  UserCar? _editingCar;

  Future<void> _onStarted(
    AddCarStarted event,
    Emitter<AddCarState> emit,
  ) async {
    final editingCar = event.initialCar ?? _editingCar;
    _editingCar = editingCar;

    emit(
      state.copyWith(
        status: AddCarStatus.loading,
        clearError: true,
        clearCreatedCar: true,
      ),
    );

    try {
      final sizes = await _repository.fetchCarSizes();
      var nextState = state.copyWith(
        status: AddCarStatus.initial,
        carSizes: sizes,
        selectedCarSizeId:
            editingCar?.carSizeId ?? (sizes.isNotEmpty ? sizes.first.id : null),
        isPrimary: editingCar?.isPrimary ?? false,
        clearError: true,
        clearCreatedCar: true,
      );
      nextState = nextState.populateFromUserCar(editingCar);
      emit(nextState);
    } catch (error) {
      emit(
        state.copyWith(
          status: AddCarStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onNameChanged(AddCarNameChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(name: event.name, clearError: true, clearCreatedCar: true),
    );
  }

  void _onBrandChanged(AddCarBrandChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(
        brand: event.brand,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onModelChanged(AddCarModelChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(
        model: event.model,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onYearChanged(AddCarYearChanged event, Emitter<AddCarState> emit) {
    final trimmed = event.year.trim();
    final parsed = trimmed.isEmpty ? null : int.tryParse(trimmed);
    emit(
      state.copyWith(
        year: parsed,
        clearYear: trimmed.isEmpty,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onColorChanged(AddCarColorChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(
        color: event.color,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onPlateChanged(AddCarPlateChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(
        plateNumber: event.plateNumber,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onSizeChanged(AddCarSizeChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(
        selectedCarSizeId: event.sizeId,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onPrimaryToggled(
    AddCarPrimaryToggled event,
    Emitter<AddCarState> emit,
  ) {
    emit(
      state.copyWith(
        isPrimary: event.isPrimary,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  void _onImageChanged(AddCarImageChanged event, Emitter<AddCarState> emit) {
    emit(
      state.copyWith(
        imagePath: event.imagePath,
        clearError: true,
        clearCreatedCar: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    AddCarSubmitted event,
    Emitter<AddCarState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: AddCarStatus.failure,
          errorMessage: 'يرجى إكمال جميع الحقول المطلوبة',
          clearCreatedCar: true,
        ),
      );
      return;
    }

    emit(state.copyWith(status: AddCarStatus.saving, clearError: true));

    try {
      final payload = CarPayload(
        name: state.name.trim().isEmpty ? null : state.name.trim(),
        brand: state.brand.trim(),
        model: state.model.trim(),
        year: state.year,
        color: state.color.trim(),
        plateNumber: state.plateNumber.trim(),
        carSizeId: state.selectedCarSizeId,
        isPrimary: state.isPrimary,
        imageUrl: state.imagePath,
      );

      final UserCar result;
      if (state.isEditing) {
        result = await _repository.updateCar(
          id: state.carId!,
          payload: payload,
        );
      } else {
        result = await _repository.createCar(payload);
      }

      emit(
        state.copyWith(
          status: AddCarStatus.success,
          createdCar: result,
          carId: result.id,
        ),
      );
      _editingCar = result;
    } catch (error) {
      emit(
        state.copyWith(
          status: AddCarStatus.failure,
          errorMessage: error.toString(),
          clearCreatedCar: true,
        ),
      );
    }
  }
}
