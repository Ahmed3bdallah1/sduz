import 'package:sudz/features/store/shared/data/store_mock_data.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class StoreProductRepository {
  const StoreProductRepository();

  StoreProduct fetchProduct(String productId) {
    return kStoreProducts.firstWhere(
      (product) => product.id == productId,
      orElse: () => kStoreProducts.first,
    );
  }

  List<StoreProduct> fetchRelatedProducts(String categoryId, String productId) {
    return kStoreProductsByCategory[categoryId]
            ?.where((product) => product.id != productId)
            .take(3)
            .toList() ??
        [];
  }
}
