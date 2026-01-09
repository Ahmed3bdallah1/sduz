import 'package:equatable/equatable.dart';
import 'package:sudz/features/store/shared/models/models.dart';

enum StoreCartStatus { initial, loading, success, failure }

extension StoreCartStatusX on StoreCartStatus {
  bool get isInitial => this == StoreCartStatus.initial;
  bool get isLoading => this == StoreCartStatus.loading;
  bool get isSuccess => this == StoreCartStatus.success;
  bool get isFailure => this == StoreCartStatus.failure;
}

class StoreCartState extends Equatable {
  final StoreCartStatus status;
  final List<StoreCartItem> items;
  final List<StoreProduct> relatedProducts;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? errorMessage;

  const StoreCartState({
    this.status = StoreCartStatus.initial,
    this.items = const [],
    this.relatedProducts = const [],
    this.subtotal = 0,
    this.deliveryFee = 20,
    this.total = 0,
    this.errorMessage,
  });

  StoreCartState copyWith({
    StoreCartStatus? status,
    List<StoreCartItem>? items,
    List<StoreProduct>? relatedProducts,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? errorMessage,
  }) {
    return StoreCartState(
      status: status ?? this.status,
      items: items ?? this.items,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        relatedProducts,
        subtotal,
        deliveryFee,
        total,
        errorMessage,
      ];
}
