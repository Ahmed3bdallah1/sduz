import 'package:sudz/features/store/shared/data/store_mock_data.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class StoreCheckoutRepository {
  const StoreCheckoutRepository();

  List<StorePaymentMethod> fetchPaymentMethods() {
    return kStorePaymentMethods;
  }
}
