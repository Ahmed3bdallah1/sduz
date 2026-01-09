import 'package:sudz/features/store/checkout/data/store_checkout_repository.dart';
import 'package:sudz/features/store/shared/models/models.dart';

class PackageCheckoutRepository {
  final StoreCheckoutRepository _storeRepository;

  const PackageCheckoutRepository({StoreCheckoutRepository? storeRepository})
    : _storeRepository = storeRepository ?? const StoreCheckoutRepository();

  List<StorePaymentMethod> fetchPaymentMethods() {
    return _storeRepository.fetchPaymentMethods();
  }
}
