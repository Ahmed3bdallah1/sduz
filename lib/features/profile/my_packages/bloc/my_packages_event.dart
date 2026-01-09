import 'package:equatable/equatable.dart';

abstract class MyPackagesEvent extends Equatable {
  const MyPackagesEvent();

  @override
  List<Object?> get props => [];
}

class MyPackagesStarted extends MyPackagesEvent {
  const MyPackagesStarted();
}

class MyPackageSelected extends MyPackagesEvent {
  final String packageId;

  const MyPackageSelected(this.packageId);

  @override
  List<Object?> get props => [packageId];
}
