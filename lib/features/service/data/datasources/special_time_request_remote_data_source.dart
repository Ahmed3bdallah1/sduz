import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/special_time_request_dto.dart';
import '../models/special_time_request_payload.dart';

class SpecialTimeRequestRemoteDataSource {
  SpecialTimeRequestRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<SpecialTimeRequestDto>> fetchRequests() async {
    final apiRequest = ApiRequest<List<SpecialTimeRequestDto>>(
      path: AppEndpoints.customer7SpecialTimeRequestsListRequests.path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseRequestList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Special time requests response is empty');
    }
    return items;
  }

  Future<SpecialTimeRequestDto> submitRequest(
    SpecialTimeRequestPayload payload,
  ) async {
    final apiRequest = ApiRequest<SpecialTimeRequestDto>(
      path: AppEndpoints.customer7SpecialTimeRequestsSubmitRequest.path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: payload.toJson(),
      parseResponse: _parseRequest,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Submit special time response is empty');
    }
    return dto;
  }

  Future<SpecialTimeRequestDto> cancelRequest(String requestId) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer7SpecialTimeRequestsCancelRequest.path,
      requestId,
    );
    final apiRequest = ApiRequest<SpecialTimeRequestDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      parseResponse: _parseRequest,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Cancel special time response is empty');
    }
    return dto;
  }

  List<SpecialTimeRequestDto> _parseRequestList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected special time requests response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(SpecialTimeRequestDto.fromJson)
        .toList(growable: false);
  }

  SpecialTimeRequestDto _parseRequest(dynamic data) {
    if (data is JsonMap) {
      return SpecialTimeRequestDto.fromJson(data);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['request'];
      if (nested is JsonMap) {
        return SpecialTimeRequestDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected special time request response');
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['requests'],
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
          segment == ':request_id',
    );

    if (replacementIndex != -1) {
      segments[replacementIndex] = id;
    } else {
      segments.add(id);
    }

    return '/${segments.join('/')}';
  }
}
