import 'package:equatable/equatable.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';

abstract class AddCarEvent extends Equatable {
  const AddCarEvent();

  @override
  List<Object?> get props => [];
}

class AddCarStarted extends AddCarEvent {
  const AddCarStarted({this.initialCar});

  final UserCar? initialCar;

  @override
  List<Object?> get props => [initialCar];
}

class AddCarNameChanged extends AddCarEvent {
  const AddCarNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class AddCarBrandChanged extends AddCarEvent {
  const AddCarBrandChanged(this.brand);

  final String brand;

  @override
  List<Object?> get props => [brand];
}

class AddCarModelChanged extends AddCarEvent {
  const AddCarModelChanged(this.model);

  final String model;

  @override
  List<Object?> get props => [model];
}

class AddCarYearChanged extends AddCarEvent {
  const AddCarYearChanged(this.year);

  final String year;

  @override
  List<Object?> get props => [year];
}

class AddCarColorChanged extends AddCarEvent {
  const AddCarColorChanged(this.color);

  final String color;

  @override
  List<Object?> get props => [color];
}

class AddCarPlateChanged extends AddCarEvent {
  const AddCarPlateChanged(this.plateNumber);

  final String plateNumber;

  @override
  List<Object?> get props => [plateNumber];
}

class AddCarSizeChanged extends AddCarEvent {
  const AddCarSizeChanged(this.sizeId);

  final int? sizeId;

  @override
  List<Object?> get props => [sizeId];
}

class AddCarPrimaryToggled extends AddCarEvent {
  const AddCarPrimaryToggled(this.isPrimary);

  final bool isPrimary;

  @override
  List<Object?> get props => [isPrimary];
}

class AddCarImageChanged extends AddCarEvent {
  const AddCarImageChanged(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}

class AddCarSubmitted extends AddCarEvent {
  const AddCarSubmitted();
}
