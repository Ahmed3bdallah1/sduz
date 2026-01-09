import 'package:equatable/equatable.dart';
import 'package:sudz/features/store/shared/models/models.dart';

enum StoreCheckoutStatus { initial, loading, success, failure }

extension StoreCheckoutStatusX on StoreCheckoutStatus {
  bool get isInitial => this == StoreCheckoutStatus.initial;
  bool get isLoading => this == StoreCheckoutStatus.loading;
  bool get isSuccess => this == StoreCheckoutStatus.success;
  bool get isFailure => this == StoreCheckoutStatus.failure;
}

class StoreCheckoutState extends Equatable {
  final StoreCheckoutStatus status;
  final List<StorePaymentMethod> paymentMethods;
  final String? selectedMethodId;
  final String addressKey;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? errorMessage;

  const StoreCheckoutState({
    this.status = StoreCheckoutStatus.initial,
    this.paymentMethods = const [],
    this.selectedMethodId,
    this.addressKey = 'store.checkout.address',
    this.subtotal = 0,
    this.deliveryFee = 20,
    this.total = 0,
    this.errorMessage,
  });

  StoreCheckoutState copyWith({
    StoreCheckoutStatus? status,
    List<StorePaymentMethod>? paymentMethods,
    String? selectedMethodId,
    String? addressKey,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? errorMessage,
  }) {
    return StoreCheckoutState(
      status: status ?? this.status,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      addressKey: addressKey ?? this.addressKey,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        paymentMethods,
        selectedMethodId,
        addressKey,
        subtotal,
        deliveryFee,
        total,
        errorMessage,
      ];
}
