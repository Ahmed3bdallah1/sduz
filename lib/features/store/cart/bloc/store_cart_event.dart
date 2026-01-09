import 'package:equatable/equatable.dart';

abstract class StoreCartEvent extends Equatable {
  const StoreCartEvent();

  @override
  List<Object?> get props => [];
}

class StoreCartStarted extends StoreCartEvent {
  const StoreCartStarted();
}

class StoreCartItemIncremented extends StoreCartEvent {
  final String productId;

  const StoreCartItemIncremented(this.productId);

  @override
  List<Object?> get props => [productId];
}

class StoreCartItemDecremented extends StoreCartEvent {
  final String productId;

  const StoreCartItemDecremented(this.productId);

  @override
  List<Object?> get props => [productId];
}
