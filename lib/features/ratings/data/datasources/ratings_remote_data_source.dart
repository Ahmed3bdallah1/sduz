import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/give_tip_payload.dart';
import '../models/rate_booking_payload.dart';
import '../models/rating_dto.dart';

class RatingsRemoteDataSource {
  RatingsRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<RatingDto>> fetchMyRatings() async {
    final apiRequest = ApiRequest<List<RatingDto>>(
      path: AppEndpoints.customer8RatingsTipsMyRatings.path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseRatingList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('My ratings response is empty');
    }
    return items;
  }

  Future<RatingDto> rateBooking({
    required String bookingId,
    required RateBookingPayload payload,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer8RatingsTipsRateBooking.path,
      bookingId,
    );
    final apiRequest = ApiRequest<RatingDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: payload.toJson(),
      parseResponse: _parseRating,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Rate booking response is empty');
    }
    return dto;
  }

  Future<RatingDto> giveTip({
    required String bookingId,
    required GiveTipPayload payload,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer8RatingsTipsGiveTip.path,
      bookingId,
    );
    final apiRequest = ApiRequest<RatingDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: payload.toJson(),
      parseResponse: _parseRating,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Give tip response is empty');
    }
    return dto;
  }

  RatingDto _parseRating(dynamic data) {
    if (data is JsonMap) {
      return RatingDto.fromJson(data);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['rating'];
      if (nested is JsonMap) {
        return RatingDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected rating response shape');
  }

  List<RatingDto> _parseRatingList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected ratings list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(RatingDto.fromJson)
        .toList(growable: false);
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['ratings'],
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
          segment == ':booking_id',
    );

    if (replacementIndex != -1) {
      segments[replacementIndex] = id;
    } else {
      segments.add(id);
    }

    return '/${segments.join('/')}';
  }
}
