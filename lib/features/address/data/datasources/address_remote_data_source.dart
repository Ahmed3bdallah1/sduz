import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/address_payload.dart';
import '../models/user_address_dto.dart';

class AddressRemoteDataSource {
  AddressRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<UserAddressDto>> fetchAddresses() async {
    final apiRequest = ApiRequest<List<UserAddressDto>>(
      path: AppEndpoints.customer2AddressesListAddresses.path,
      method: HttpMethod.get,
      parseResponse: _parseAddressList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Address list response is empty');
    }
    return items;
  }

  Future<UserAddressDto> createAddress(AddressPayload payload) async {
    final apiRequest = ApiRequest<UserAddressDto>(
      path: AppEndpoints.customer2AddressesCreateAddress.path,
      method: HttpMethod.post,
      data: payload.toJson(),
      parseResponse: _parseAddress,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Create address response is empty');
    }
    return dto;
  }

  Future<UserAddressDto> updateAddress({
    required String id,
    required AddressPayload payload,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer2AddressesUpdateAddress.path,
      id,
    );
    final apiRequest = ApiRequest<UserAddressDto>(
      path: path,
      method: HttpMethod.put,
      data: payload.toJson(),
      parseResponse: _parseAddress,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Update address response is empty');
    }
    return dto;
  }

  Future<void> deleteAddress(String id) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer2AddressesDeleteAddress.path,
      id,
    );
    final apiRequest = ApiRequest<void>(path: path, method: HttpMethod.delete);
    await _client.send(apiRequest);
  }

  Future<UserAddressDto> setDefault(String id) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer2AddressesSetDefaultAddress.path,
      id,
    );
    final apiRequest = ApiRequest<UserAddressDto>(
      path: path,
      method: HttpMethod.post,
      parseResponse: _parseAddress,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Set default address response is empty');
    }
    return dto;
  }

  List<UserAddressDto> _parseAddressList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected address list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(UserAddressDto.fromJson)
        .toList(growable: false);
  }

  UserAddressDto _parseAddress(dynamic data) {
    if (data is JsonMap) {
      return UserAddressDto.fromJson(data);
    }
    if (data is List && data.isNotEmpty && data.first is JsonMap) {
      return UserAddressDto.fromJson(data.first as JsonMap);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is JsonMap) {
        return UserAddressDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected address response shape');
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['addresses'],
        data['items'],
        data['results'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return null;
  }

  String _replaceIdSegment(String path, String id) {
    final segments = path
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
    final replacementIndex = segments.indexWhere(
      (segment) =>
          segment == '1' ||
          segment == ':id' ||
          segment == '{id}' ||
          segment == ':address_id',
    );

    if (replacementIndex != -1) {
      segments[replacementIndex] = id;
    } else {
      segments.add(id);
    }

    return '/${segments.join('/')}';
  }
}
