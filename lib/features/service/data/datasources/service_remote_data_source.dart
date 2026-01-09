import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/service_category_dto.dart';
import '../models/service_dto.dart';

class ServiceRemoteDataSource {
  ServiceRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<ServiceCategoryDto>> fetchServiceCategories() async {
    final apiRequest = ApiRequest<List<ServiceCategoryDto>>(
      path: AppEndpoints.customer4ServicesListServiceCategories.path,
      method: HttpMethod.get,
      requiresAuth: false,
      parseResponse: _parseServiceCategoryList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Service categories response is empty');
    }
    return items;
  }

  Future<List<ServiceDto>> fetchServices({String? categoryId}) async {
    final queryParameters = categoryId != null
        ? <String, dynamic>{'category_id': categoryId}
        : null;

    final apiRequest = ApiRequest<List<ServiceDto>>(
      path: AppEndpoints.customer4ServicesBrowseServices.path,
      method: HttpMethod.get,
      requiresAuth: false,
      queryParameters: queryParameters,
      parseResponse: _parseServiceList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Services list response is empty');
    }
    return items;
  }

  Future<ServiceDto> fetchServiceDetails(String serviceId) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer4ServicesServiceDetails.path,
      serviceId,
    );
    final apiRequest = ApiRequest<ServiceDto>(
      path: path,
      method: HttpMethod.get,
      requiresAuth: false,
      parseResponse: _parseService,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Service details response is empty');
    }
    return dto;
  }

  List<ServiceCategoryDto> _parseServiceCategoryList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected service categories response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(ServiceCategoryDto.fromJson)
        .toList(growable: false);
  }

  List<ServiceDto> _parseServiceList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected services list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(ServiceDto.fromJson)
        .toList(growable: false);
  }

  ServiceDto _parseService(dynamic data) {
    if (data is JsonMap) {
      return ServiceDto.fromJson(data);
    }
    if (data is List && data.isNotEmpty && data.first is JsonMap) {
      return ServiceDto.fromJson(data.first as JsonMap);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['service'];
      if (nested is JsonMap) {
        return ServiceDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected service response shape');
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['services'],
        data['categories'],
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
          segment == ':service_id',
    );

    if (replacementIndex != -1) {
      segments[replacementIndex] = id;
    } else {
      segments.add(id);
    }

    return '/${segments.join('/')}';
  }
}

