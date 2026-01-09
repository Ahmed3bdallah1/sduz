import 'package:equatable/equatable.dart';

abstract class PackagesEvent extends Equatable {
  const PackagesEvent();

  @override
  List<Object?> get props => [];
}

class PackagesStarted extends PackagesEvent {
  const PackagesStarted();
}

class PackageSelectionChanged extends PackagesEvent {
  final String packageId;

  const PackageSelectionChanged(this.packageId);

  @override
  List<Object?> get props => [packageId];
}
