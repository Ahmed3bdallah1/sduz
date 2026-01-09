import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/package_dto.dart';
import '../models/purchase_package_payload.dart';
import '../models/user_package_dto.dart';

class PackagesRemoteDataSource {
  PackagesRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<PackageDto>> fetchPackages() async {
    final apiRequest = ApiRequest<List<PackageDto>>(
      path: AppEndpoints.customer5PackagesListPackages.path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parsePackageList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Packages list response is empty');
    }
    return items;
  }

  Future<PackageDto> fetchPackageDetails(String packageId) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer5PackagesPackageDetails.path,
      packageId,
    );
    final apiRequest = ApiRequest<PackageDto>(
      path: path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parsePackage,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Package details response is empty');
    }
    return dto;
  }

  Future<UserPackageDto> purchasePackage({
    required String packageId,
    required PurchasePackagePayload payload,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer5PackagesPurchasePackage.path,
      packageId,
    );
    final apiRequest = ApiRequest<UserPackageDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: payload.toJson(),
      parseResponse: _parseUserPackage,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Purchase package response is empty');
    }
    return dto;
  }

  Future<List<UserPackageDto>> fetchMyActivePackages() async {
    final apiRequest = ApiRequest<List<UserPackageDto>>(
      path: AppEndpoints.customer5PackagesMyActivePackages.path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseUserPackageList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('My packages response is empty');
    }
    return items;
  }

  List<PackageDto> _parsePackageList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected packages list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(PackageDto.fromJson)
        .toList(growable: false);
  }

  PackageDto _parsePackage(dynamic data) {
    if (data is JsonMap) {
      return PackageDto.fromJson(data);
    }
    if (data is List && data.isNotEmpty && data.first is JsonMap) {
      return PackageDto.fromJson(data.first as JsonMap);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['package'];
      if (nested is JsonMap) {
        return PackageDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected package response shape');
  }

  List<UserPackageDto> _parseUserPackageList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected user packages list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(UserPackageDto.fromJson)
        .toList(growable: false);
  }

  UserPackageDto _parseUserPackage(dynamic data) {
    if (data is JsonMap) {
      return UserPackageDto.fromJson(data);
    }
    if (data is List && data.isNotEmpty && data.first is JsonMap) {
      return UserPackageDto.fromJson(data.first as JsonMap);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['user_package'] ?? data['package'];
      if (nested is JsonMap) {
        return UserPackageDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected user package response shape');
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['packages'],
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
          segment == ':package_id',
    );

    if (replacementIndex != -1) {
      segments[replacementIndex] = id;
    } else {
      segments.add(id);
    }

    return '/${segments.join('/')}';
  }
}

