import 'package:equatable/equatable.dart';
import 'package:sudz/features/store/shared/models/models.dart';

enum StoreProductStatus { initial, loading, success, failure }

extension StoreProductStatusX on StoreProductStatus {
  bool get isInitial => this == StoreProductStatus.initial;
  bool get isLoading => this == StoreProductStatus.loading;
  bool get isSuccess => this == StoreProductStatus.success;
  bool get isFailure => this == StoreProductStatus.failure;
}

class StoreProductState extends Equatable {
  final StoreProductStatus status;
  final StoreProduct? product;
  final List<StoreProduct> relatedProducts;
  final String? errorMessage;

  const StoreProductState({
    this.status = StoreProductStatus.initial,
    this.product,
    this.relatedProducts = const [],
    this.errorMessage,
  });

  StoreProductState copyWith({
    StoreProductStatus? status,
    StoreProduct? product,
    List<StoreProduct>? relatedProducts,
    String? errorMessage,
  }) {
    return StoreProductState(
      status: status ?? this.status,
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, relatedProducts, errorMessage];
}
