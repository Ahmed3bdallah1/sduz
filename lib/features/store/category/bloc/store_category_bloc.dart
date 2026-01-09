import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/store/category/bloc/store_category_event.dart';
import 'package:sudz/features/store/category/bloc/store_category_state.dart';
import 'package:sudz/features/store/category/data/store_category_repository.dart';

class StoreCategoryBloc
    extends Bloc<StoreCategoryEvent, StoreCategoryState> {
  final StoreCategoryRepository _repository;

  StoreCategoryBloc({StoreCategoryRepository? repository})
      : _repository = repository ?? const StoreCategoryRepository(),
        super(const StoreCategoryState()) {
    on<StoreCategoryStarted>(_onStarted);
    on<StoreCategoryFilterChanged>(_onFilterChanged);
    on<StoreCategoryLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onStarted(
    StoreCategoryStarted event,
    Emitter<StoreCategoryState> emit,
  ) async {
    emit(state.copyWith(status: StoreCategoryStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 250));

    final category = _repository.fetchCategory(event.categoryId);
    final filters = _repository.fetchFilters(event.categoryId);
    final products = _repository.fetchProducts(event.categoryId);

    emit(
      state.copyWith(
        status: StoreCategoryStatus.success,
        category: category,
        filters: filters,
        selectedFilterId: filters.isNotEmpty ? filters.first.id : null,
        products: products.take(6).toList(),
        hasMore: products.length > 6,
        errorMessage: null,
      ),
    );
  }

  void _onFilterChanged(
    StoreCategoryFilterChanged event,
    Emitter<StoreCategoryState> emit,
  ) {
    if (state.status.isLoading || state.category == null) return;
    final filteredProducts =
        _repository.fetchProducts(state.category!.id);

    emit(
      state.copyWith(
        selectedFilterId: event.filterId,
        products: filteredProducts.take(6).toList(),
        hasMore: filteredProducts.length > 6,
      ),
    );
  }

  void _onLoadMore(
    StoreCategoryLoadMoreRequested event,
    Emitter<StoreCategoryState> emit,
  ) {
    if (state.category == null) return;
    final products = _repository.fetchProducts(state.category!.id);
    final currentCount = state.products.length;
    if (currentCount >= products.length) {
      emit(state.copyWith(hasMore: false));
      return;
    }
    final nextCount = (currentCount + 6).clamp(0, products.length);
    emit(
      state.copyWith(
        products: products.take(nextCount).toList(),
        hasMore: nextCount < products.length,
      ),
    );
  }
}
