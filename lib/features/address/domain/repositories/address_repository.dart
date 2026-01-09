import '../entities/user_address.dart';
import '../../data/models/address_payload.dart';

abstract class AddressRepository {
  Future<List<UserAddress>> fetchAddresses();

  Future<UserAddress> createAddress(AddressPayload payload);

  Future<UserAddress> updateAddress({
    required String id,
    required AddressPayload payload,
  });

  Future<void> deleteAddress(String id);

  Future<UserAddress> setDefault(String id);
}
