import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/store/product/bloc/store_product_event.dart';
import 'package:sudz/features/store/product/bloc/store_product_state.dart';
import 'package:sudz/features/store/product/data/store_product_repository.dart';

class StoreProductBloc extends Bloc<StoreProductEvent, StoreProductState> {
  final StoreProductRepository _repository;

  StoreProductBloc({StoreProductRepository? repository})
      : _repository = repository ?? const StoreProductRepository(),
        super(const StoreProductState()) {
    on<StoreProductStarted>(_onStarted);
  }

  Future<void> _onStarted(
    StoreProductStarted event,
    Emitter<StoreProductState> emit,
  ) async {
    emit(state.copyWith(status: StoreProductStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final product = _repository.fetchProduct(event.productId);

    emit(
      state.copyWith(
        status: StoreProductStatus.success,
        product: product,
        relatedProducts: _repository.fetchRelatedProducts(
          product.categoryId,
          product.id,
        ),
        errorMessage: null,
      ),
    );
  }
}
