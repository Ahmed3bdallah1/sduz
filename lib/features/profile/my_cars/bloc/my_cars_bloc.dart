import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/features/car/domain/repositories/car_repository.dart';
import 'package:sudz/features/profile/my_cars/bloc/my_cars_event.dart';
import 'package:sudz/features/profile/my_cars/bloc/my_cars_state.dart';
import 'package:sudz/features/profile/shared/models/profile_car.dart';

class MyCarsBloc extends Bloc<MyCarsEvent, MyCarsState> {
  MyCarsBloc({required CarRepository carRepository})
    : _repository = carRepository,
      super(const MyCarsState()) {
    on<MyCarsStarted>(_onStarted);
    on<MyCarSelected>(_onCarSelected);
    on<MyCarDeleted>(_onCarDeleted);
    on<MyCarSetPrimary>(_onSetPrimary);
  }

  final CarRepository _repository;

  Future<void> _onStarted(
    MyCarsStarted event,
    Emitter<MyCarsState> emit,
  ) async {
    if (event.showLoader) {
      emit(state.copyWith(status: MyCarsStatus.loading, errorMessage: null));
    }

    try {
      final cars = await _repository.fetchCars();
      _emitWithCars(emit, cars);
    } catch (error) {
      emit(
        state.copyWith(
          status: MyCarsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onCarSelected(MyCarSelected event, Emitter<MyCarsState> emit) {
    if (state.cars.any((car) => car.id == event.carId)) {
      emit(state.copyWith(selectedCarId: event.carId));
    }
  }

  Future<void> _onCarDeleted(
    MyCarDeleted event,
    Emitter<MyCarsState> emit,
  ) async {
    emit(state.copyWith(mutationStatus: MyCarsMutationStatus.inProgress));
    try {
      await _repository.deleteCar(event.carId);
      final cars = await _repository.fetchCars();
      _emitWithCars(emit, cars);
      emit(
        state.copyWith(
          mutationStatus: MyCarsMutationStatus.success,
          mutationMessage: 'تم حذف السيارة بنجاح',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          mutationStatus: MyCarsMutationStatus.failure,
          mutationMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSetPrimary(
    MyCarSetPrimary event,
    Emitter<MyCarsState> emit,
  ) async {
    emit(state.copyWith(mutationStatus: MyCarsMutationStatus.inProgress));
    try {
      await _repository.setPrimaryCar(event.carId);
      final cars = await _repository.fetchCars();
      _emitWithCars(emit, cars);
      emit(
        state.copyWith(
          mutationStatus: MyCarsMutationStatus.success,
          mutationMessage: 'تم تعيين السيارة كافتراضية',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          mutationStatus: MyCarsMutationStatus.failure,
          mutationMessage: error.toString(),
        ),
      );
    }
  }

  void _emitWithCars(Emitter<MyCarsState> emit, List<UserCar> cars) {
    final profileCars = cars
        .map(ProfileCar.fromUserCar)
        .toList(growable: false);
    ProfileCar? initialSelection;
    for (final car in profileCars) {
      if (car.isPrimary) {
        initialSelection = car;
        break;
      }
    }
    initialSelection ??= profileCars.isNotEmpty ? profileCars.first : null;

    emit(
      state.copyWith(
        status: MyCarsStatus.success,
        cars: profileCars,
        userCars: cars,
        selectedCarId: initialSelection?.id,
        mutationStatus: MyCarsMutationStatus.idle,
        mutationMessage: null,
        errorMessage: null,
      ),
    );
  }
}
