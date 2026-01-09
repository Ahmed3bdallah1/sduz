import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/car_dto.dart';
import '../models/car_payload.dart';
import '../models/car_size_dto.dart';

class CarRemoteDataSource {
  CarRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<CarDto>> fetchCars() async {
    final apiRequest = ApiRequest<List<CarDto>>(
      path: AppEndpoints.customer3CarsListCars.path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseCarList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Cars response is empty');
    }
    return items;
  }

  Future<List<CarSizeDto>> fetchCarSizes() async {
    final apiRequest = ApiRequest<List<CarSizeDto>>(
      path: AppEndpoints.customer3CarsGetCarSizes.path,
      method: HttpMethod.get,
      requiresAuth: false,
      parseResponse: _parseCarSizeList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Car sizes response is empty');
    }
    return items;
  }

  Future<CarDto> createCar(CarPayload payload) async {
    final apiRequest = ApiRequest<CarDto>(
      path: AppEndpoints.customer3CarsAddCar.path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: payload.toJson(),
      parseResponse: _parseCar,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Create car response is empty');
    }
    return dto;
  }

  Future<CarDto> updateCar({
    required String id,
    required CarPayload payload,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer3CarsUpdateCar.path,
      id,
    );
    final apiRequest = ApiRequest<CarDto>(
      path: path,
      method: HttpMethod.put,
      requiresAuth: true,
      data: payload.toJson(),
      parseResponse: _parseCar,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Update car response is empty');
    }
    return dto;
  }

  Future<void> deleteCar(String id) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer3CarsDeleteCar.path,
      id,
    );
    final apiRequest = ApiRequest<void>(
      path: path,
      method: HttpMethod.delete,
      requiresAuth: true,
    );
    await _client.send(apiRequest);
  }

  Future<CarDto> setPrimaryCar(String id) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer3CarsSetPrimaryCar.path,
      id,
    );
    final apiRequest = ApiRequest<CarDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      parseResponse: _parseCar,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Set primary car response is empty');
    }
    return dto;
  }

  List<CarDto> _parseCarList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected cars list shape');
    }
    return rawList
        .whereType<JsonMap>()
        .map(CarDto.fromJson)
        .toList(growable: false);
  }

  List<CarSizeDto> _parseCarSizeList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected car sizes response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(CarSizeDto.fromJson)
        .toList(growable: false);
  }

  CarDto _parseCar(dynamic data) {
    if (data is JsonMap) {
      return CarDto.fromJson(data);
    }
    if (data is List && data.isNotEmpty && data.first is JsonMap) {
      return CarDto.fromJson(data.first as JsonMap);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is JsonMap) {
        return CarDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected car response shape');
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['cars'],
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
        .toList(growable: true);
    final index = segments.indexWhere(
      (segment) =>
          segment == '1' ||
          segment == ':id' ||
          segment == '{id}' ||
          segment == ':car_id',
    );
    if (index != -1) {
      segments[index] = id;
    } else {
      segments.add(id);
    }
    return '/${segments.join('/')}';
  }
}
