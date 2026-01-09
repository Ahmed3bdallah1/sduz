import 'package:equatable/equatable.dart';

abstract class StoreProductEvent extends Equatable {
  const StoreProductEvent();

  @override
  List<Object?> get props => [];
}

class StoreProductStarted extends StoreProductEvent {
  final String productId;

  const StoreProductStarted(this.productId);

  @override
  List<Object?> get props => [productId];
}
