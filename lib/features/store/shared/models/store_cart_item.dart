import 'package:equatable/equatable.dart';
import 'store_product.dart';

class StoreCartItem extends Equatable {
  final StoreProduct product;
  final int quantity;

  const StoreCartItem({
    required this.product,
    required this.quantity,
  });

  StoreCartItem copyWith({int? quantity}) {
    return StoreCartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
