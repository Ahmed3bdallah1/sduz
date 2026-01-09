import 'package:equatable/equatable.dart';
import 'package:sudz/features/packages/data/models/models.dart';
import 'package:sudz/features/store/shared/models/models.dart';

enum PackageCheckoutStatus {
  initial,
  loading,
  ready,
  processing,
  success,
  failure,
}

extension PackageCheckoutStatusX on PackageCheckoutStatus {
  bool get isInitial => this == PackageCheckoutStatus.initial;
  bool get isLoading => this == PackageCheckoutStatus.loading;
  bool get isReady => this == PackageCheckoutStatus.ready;
  bool get isProcessing => this == PackageCheckoutStatus.processing;
  bool get isSuccess => this == PackageCheckoutStatus.success;
  bool get isFailure => this == PackageCheckoutStatus.failure;
}

class PackageCheckoutState extends Equatable {
  final PackageCheckoutStatus status;
  final Package? package;
  final List<StorePaymentMethod> paymentMethods;
  final String? selectedMethodId;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? errorMessage;
  final String? purchasedPackageId;

  const PackageCheckoutState({
    this.status = PackageCheckoutStatus.initial,
    this.package,
    this.paymentMethods = const [],
    this.selectedMethodId,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.total = 0,
    this.errorMessage,
    this.purchasedPackageId,
  });

  PackageCheckoutState copyWith({
    PackageCheckoutStatus? status,
    Package? package,
    List<StorePaymentMethod>? paymentMethods,
    String? selectedMethodId,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? errorMessage,
    String? purchasedPackageId,
  }) {
    return PackageCheckoutState(
      status: status ?? this.status,
      package: package ?? this.package,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      errorMessage: errorMessage,
      purchasedPackageId: purchasedPackageId ?? this.purchasedPackageId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    package,
    paymentMethods,
    selectedMethodId,
    subtotal,
    deliveryFee,
    total,
    errorMessage,
    purchasedPackageId,
  ];
}
