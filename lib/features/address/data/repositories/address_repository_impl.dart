import '../../domain/entities/user_address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import '../models/address_payload.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl(this._remote);

  final AddressRemoteDataSource _remote;

  @override
  Future<List<UserAddress>> fetchAddresses() async {
    final response = await _remote.fetchAddresses();
    return response.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<UserAddress> createAddress(AddressPayload payload) async {
    final dto = await _remote.createAddress(payload);
    return dto.toEntity();
  }

  @override
  Future<UserAddress> updateAddress({
    required String id,
    required AddressPayload payload,
  }) async {
    final dto = await _remote.updateAddress(id: id, payload: payload);
    return dto.toEntity();
  }

  @override
  Future<void> deleteAddress(String id) {
    return _remote.deleteAddress(id);
  }

  @override
  Future<UserAddress> setDefault(String id) async {
    final dto = await _remote.setDefault(id);
    return dto.toEntity();
  }
}
