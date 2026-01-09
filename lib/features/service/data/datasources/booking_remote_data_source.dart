import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/booking_dto.dart';
import '../models/booking_timeline_entry_dto.dart';
import '../models/cancel_booking_request.dart';
import '../models/create_booking_request.dart';
import '../models/reschedule_booking_request.dart';

class BookingRemoteDataSource {
  BookingRemoteDataSource(this._client);

  final DioClient _client;

  Future<BookingDto> createBooking(CreateBookingRequest request) async {
    final apiRequest = ApiRequest<BookingDto>(
      path: AppEndpoints.customer6BookingsCreateBooking.path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: request.toJson(),
      parseResponse: _parseBooking,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Create booking response is empty');
    }
    return dto;
  }

  Future<List<BookingDto>> fetchBookings({String? status}) async {
    final queryParameters = status != null
        ? <String, dynamic>{'status': status}
        : null;

    final apiRequest = ApiRequest<List<BookingDto>>(
      path: AppEndpoints.customer6BookingsListBookings.path
          .split('?')
          .first, // Remove default query params
      method: HttpMethod.get,
      requiresAuth: true,
      queryParameters: queryParameters,
      parseResponse: _parseBookingList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Bookings list response is empty');
    }
    return items;
  }

  Future<BookingDto> fetchBookingDetails(String bookingId) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer6BookingsBookingDetails.path,
      bookingId,
    );
    final apiRequest = ApiRequest<BookingDto>(
      path: path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseBooking,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Booking details response is empty');
    }
    return dto;
  }

  Future<BookingDto> rescheduleBooking({
    required String bookingId,
    required RescheduleBookingRequest request,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer6BookingsRescheduleBooking.path,
      bookingId,
    );
    final apiRequest = ApiRequest<BookingDto>(
      path: path,
      method: HttpMethod.put,
      requiresAuth: true,
      data: request.toJson(),
      parseResponse: _parseBooking,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Reschedule booking response is empty');
    }
    return dto;
  }

  Future<BookingDto> cancelBooking({
    required String bookingId,
    required CancelBookingRequest request,
  }) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer6BookingsCancelBooking.path,
      bookingId,
    );
    final apiRequest = ApiRequest<BookingDto>(
      path: path,
      method: HttpMethod.post,
      requiresAuth: true,
      data: request.toJson(),
      parseResponse: _parseBooking,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Cancel booking response is empty');
    }
    return dto;
  }

  Future<List<BookingTimelineEntryDto>> fetchBookingTimeline(
    String bookingId,
  ) async {
    final path = _replaceIdSegment(
      AppEndpoints.customer6BookingsBookingTimeline.path,
      bookingId,
    );
    final apiRequest = ApiRequest<List<BookingTimelineEntryDto>>(
      path: path,
      method: HttpMethod.get,
      requiresAuth: true,
      parseResponse: _parseTimelineList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Booking timeline response is empty');
    }
    return items;
  }

  BookingDto _parseBooking(dynamic data) {
    if (data is JsonMap) {
      return BookingDto.fromJson(data);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['booking'];
      if (nested is JsonMap) {
        return BookingDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected booking response shape');
  }

  List<BookingDto> _parseBookingList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected bookings list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(BookingDto.fromJson)
        .toList(growable: false);
  }

  List<BookingTimelineEntryDto> _parseTimelineList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected booking timeline response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(BookingTimelineEntryDto.fromJson)
        .toList(growable: false);
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['bookings'],
        data['timeline'],
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
