import 'package:equatable/equatable.dart';
import 'package:sudz/features/packages/data/models/models.dart';

enum PackagesStatus { initial, loading, success, failure }

extension PackagesStatusX on PackagesStatus {
  bool get isInitial => this == PackagesStatus.initial;
  bool get isLoading => this == PackagesStatus.loading;
  bool get isSuccess => this == PackagesStatus.success;
  bool get isFailure => this == PackagesStatus.failure;
}

class PackagesState extends Equatable {
  final PackagesStatus status;
  final List<Package> packages;
  final String? selectedPackageId;
  final String? errorMessage;

  const PackagesState({
    this.status = PackagesStatus.initial,
    this.packages = const [],
    this.selectedPackageId,
    this.errorMessage,
  });

  Package? get selectedPackage {
    if (selectedPackageId == null) return null;
    try {
      return packages.firstWhere((pkg) => pkg.id == selectedPackageId);
    } catch (_) {
      return null;
    }
  }

  double get totalPrice => selectedPackage?.price ?? 0;

  PackagesState copyWith({
    PackagesStatus? status,
    List<Package>? packages,
    String? selectedPackageId,
    String? errorMessage,
  }) {
    return PackagesState(
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
