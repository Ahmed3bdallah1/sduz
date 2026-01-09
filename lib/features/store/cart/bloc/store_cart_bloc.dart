import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/store/cart/bloc/store_cart_event.dart';
import 'package:sudz/features/store/cart/bloc/store_cart_state.dart';
import 'package:sudz/features/store/cart/data/store_cart_repository.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class StoreCartBloc extends Bloc<StoreCartEvent, StoreCartState> {
  final StoreCartRepository _repository;

  StoreCartBloc({StoreCartRepository? repository})
      : _repository = repository ?? const StoreCartRepository(),
        super(const StoreCartState()) {
    on<StoreCartStarted>(_onStarted);
    on<StoreCartItemIncremented>(_onIncremented);
    on<StoreCartItemDecremented>(_onDecremented);
  }

  Future<void> _onStarted(
    StoreCartStarted event,
    Emitter<StoreCartState> emit,
  ) async {
    emit(state.copyWith(status: StoreCartStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final items = _repository.fetchCartItems();
    final related = _repository.fetchRelatedProducts();
    final subtotal = _calculateSubtotal(items);
    emit(
      state.copyWith(
        status: StoreCartStatus.success,
        items: items,
        relatedProducts: related,
        subtotal: subtotal,
        total: subtotal + state.deliveryFee,
      ),
    );
  }

  void _onIncremented(
    StoreCartItemIncremented event,
    Emitter<StoreCartState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == event.productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    _updateTotals(emit, updatedItems);
  }

  void _onDecremented(
    StoreCartItemDecremented event,
    Emitter<StoreCartState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item.product.id == event.productId) {
        final nextQuantity = (item.quantity - 1).clamp(0, item.quantity);
        return item.copyWith(quantity: nextQuantity);
      }
      return item;
    }).where((item) => item.quantity > 0).toList();
    _updateTotals(emit, updatedItems);
  }

  void _updateTotals(Emitter<StoreCartState> emit, List<StoreCartItem> items) {
    final subtotal = _calculateSubtotal(items);
    emit(
      state.copyWith(
        items: items,
        subtotal: subtotal,
        total: subtotal + state.deliveryFee,
      ),
    );
  }
}

double _calculateSubtotal(List<StoreCartItem> items) {
  return items.fold<double>(0, (sum, item) => sum + item.totalPrice);
}
