import 'package:equatable/equatable.dart';
import 'package:sudz/features/store/shared/models/models.dart';

enum StoreCategoryStatus { initial, loading, success, failure }

extension StoreCategoryStatusX on StoreCategoryStatus {
  bool get isInitial => this == StoreCategoryStatus.initial;
  bool get isLoading => this == StoreCategoryStatus.loading;
  bool get isSuccess => this == StoreCategoryStatus.success;
  bool get isFailure => this == StoreCategoryStatus.failure;
}

class StoreCategoryState extends Equatable {
  final StoreCategoryStatus status;
  final StoreCategory? category;
  final List<StoreFilterOption> filters;
  final String? selectedFilterId;
  final List<StoreProduct> products;
  final bool hasMore;
  final String? errorMessage;

  const StoreCategoryState({
    this.status = StoreCategoryStatus.initial,
    this.category,
    this.filters = const [],
    this.selectedFilterId,
    this.products = const [],
    this.hasMore = false,
    this.errorMessage,
  });

  StoreCategoryState copyWith({
    StoreCategoryStatus? status,
    StoreCategory? category,
    List<StoreFilterOption>? filters,
    String? selectedFilterId,
    List<StoreProduct>? products,
    bool? hasMore,
    String? errorMessage,
  }) {
    return StoreCategoryState(
      status: status ?? this.status,
      category: category ?? this.category,
      filters: filters ?? this.filters,
      selectedFilterId: selectedFilterId ?? this.selectedFilterId,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        category,
        filters,
        selectedFilterId,
        products,
        hasMore,
        errorMessage,
      ];
}
