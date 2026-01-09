import 'package:equatable/equatable.dart';

class CarSize extends Equatable {
  const CarSize({required this.id, required this.name, this.description});

  final int id;
  final String name;
  final String? description;

  @override
  List<Object?> get props => [id, name, description];
}
