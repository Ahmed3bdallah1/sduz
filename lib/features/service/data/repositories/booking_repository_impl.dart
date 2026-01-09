import '../../domain/entities/booking.dart';
import '../../domain/entities/booking_timeline_entry.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/cancel_booking_request.dart';
import '../models/create_booking_request.dart';
import '../models/reschedule_booking_request.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._remoteDataSource);

  final BookingRemoteDataSource _remoteDataSource;

  @override
  Future<Booking> createBooking(CreateBookingRequest request) async {
    final dto = await _remoteDataSource.createBooking(request);
    return dto.toEntity();
  }

  @override
  Future<List<Booking>> fetchBookings({String? status}) async {
    final dtos = await _remoteDataSource.fetchBookings(status: status);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Booking> fetchBookingDetails(String bookingId) async {
    final dto = await _remoteDataSource.fetchBookingDetails(bookingId);
    return dto.toEntity();
  }

  @override
  Future<Booking> cancelBooking({
    required String bookingId,
    required CancelBookingRequest request,
  }) async {
    final dto = await _remoteDataSource.cancelBooking(
      bookingId: bookingId,
      request: request,
    );
    return dto.toEntity();
  }

  @override
  Future<Booking> rescheduleBooking({
    required String bookingId,
    required RescheduleBookingRequest request,
  }) async {
    final dto = await _remoteDataSource.rescheduleBooking(
      bookingId: bookingId,
      request: request,
    );
    return dto.toEntity();
  }

  @override
  Future<List<BookingTimelineEntry>> fetchBookingTimeline(
    String bookingId,
  ) async {
    final dtos = await _remoteDataSource.fetchBookingTimeline(bookingId);
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }
}
