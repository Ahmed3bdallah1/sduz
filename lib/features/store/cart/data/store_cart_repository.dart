import 'package:sudz/features/store/shared/data/store_mock_data.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class StoreCartRepository {
  const StoreCartRepository();

  List<StoreCartItem> fetchCartItems() {
    return kInitialCartItems;
  }

  List<StoreProduct> fetchRelatedProducts() {
    return kStoreProducts.take(3).toList();
  }
}
