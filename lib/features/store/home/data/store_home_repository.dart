import 'package:sudz/features/store/shared/data/store_mock_data.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class StoreHomeRepository {
  const StoreHomeRepository();

  List<StoreCategory> fetchCategories() {
    return kStoreCategories;
  }
}
