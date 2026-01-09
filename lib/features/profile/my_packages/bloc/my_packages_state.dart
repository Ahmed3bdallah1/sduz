import 'package:equatable/equatable.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

enum MyPackagesStatus { initial, loading, success, failure }

extension MyPackagesStatusX on MyPackagesStatus {
  bool get isInitial => this == MyPackagesStatus.initial;
  bool get isLoading => this == MyPackagesStatus.loading;
  bool get isSuccess => this == MyPackagesStatus.success;
  bool get isFailure => this == MyPackagesStatus.failure;
}

class MyPackagesState extends Equatable {
  final MyPackagesStatus status;
  final List<ProfilePackage> packages;
  final String? selectedPackageId;
  final String? errorMessage;

  const MyPackagesState({
    this.status = MyPackagesStatus.initial,
    this.packages = const [],
    this.selectedPackageId,
    this.errorMessage,
  });

  ProfilePackage? get selectedPackage {
    if (selectedPackageId == null) return null;
    try {
      return packages.firstWhere((pkg) => pkg.id == selectedPackageId);
    } catch (_) {
      return null;
    }
  }

  MyPackagesState copyWith({
    MyPackagesStatus? status,
    List<ProfilePackage>? packages,
    String? selectedPackageId,
    String? errorMessage,
  }) {
    return MyPackagesState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        packages,
        selectedPackageId,
        errorMessage,
      ];
}
