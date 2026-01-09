import 'package:sudz/features/store/shared/data/store_mock_data.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class StoreCategoryRepository {
  const StoreCategoryRepository();

  List<StoreFilterOption> fetchFilters(String categoryId) {
    return kDefaultFilters;
  }

  List<StoreProduct> fetchProducts(String categoryId) {
    return kStoreProductsByCategory[categoryId] ?? [];
  }

  StoreCategory fetchCategory(String categoryId) {
    return kStoreCategories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => kStoreCategories.first,
    );
  }
}
