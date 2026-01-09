import 'package:equatable/equatable.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

enum MyCarsStatus { initial, loading, success, failure }

extension MyCarsStatusX on MyCarsStatus {
  bool get isInitial => this == MyCarsStatus.initial;
  bool get isLoading => this == MyCarsStatus.loading;
  bool get isSuccess => this == MyCarsStatus.success;
  bool get isFailure => this == MyCarsStatus.failure;
}

enum MyCarsMutationStatus { idle, inProgress, success, failure }

class MyCarsState extends Equatable {
  final MyCarsStatus status;
  final List<ProfileCar> cars;
  final List<UserCar> userCars;
  final String? selectedCarId;
  final String? errorMessage;
  final MyCarsMutationStatus mutationStatus;
  final String? mutationMessage;

  const MyCarsState({
    this.status = MyCarsStatus.initial,
    this.cars = const [],
    this.userCars = const [],
    this.selectedCarId,
    this.errorMessage,
    this.mutationStatus = MyCarsMutationStatus.idle,
    this.mutationMessage,
  });

  ProfileCar? get selectedCar {
    if (selectedCarId == null) return null;
    try {
      return cars.firstWhere((car) => car.id == selectedCarId);
    } catch (_) {
      return null;
    }
  }

  UserCar? findUserCar(String id) {
    try {
      return userCars.firstWhere((car) => car.id == id);
    } catch (_) {
      return null;
    }
  }

  MyCarsState copyWith({
    MyCarsStatus? status,
    List<ProfileCar>? cars,
    List<UserCar>? userCars,
    String? selectedCarId,
    String? errorMessage,
    MyCarsMutationStatus? mutationStatus,
    String? mutationMessage,
  }) {
    return MyCarsState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      userCars: userCars ?? this.userCars,
      selectedCarId: selectedCarId ?? this.selectedCarId,
      errorMessage: errorMessage,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      mutationMessage: mutationMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cars,
    userCars,
    selectedCarId,
    errorMessage,
    mutationStatus,
    mutationMessage,
  ];
}
