import '../entities/booking.dart';
import '../entities/booking_timeline_entry.dart';
import '../../data/models/create_booking_request.dart';
import '../../data/models/cancel_booking_request.dart';
import '../../data/models/reschedule_booking_request.dart';

abstract class BookingRepository {
  /// Create a new booking
  Future<Booking> createBooking(CreateBookingRequest request);

  /// Fetch all bookings, optionally filtered by status
  Future<List<Booking>> fetchBookings({String? status});

  /// Fetch details of a specific booking
  Future<Booking> fetchBookingDetails(String bookingId);

  /// Cancel a booking with a reason
  Future<Booking> cancelBooking({
    required String bookingId,
    required CancelBookingRequest request,
  });

  /// Reschedule a booking to a new time window
  Future<Booking> rescheduleBooking({
    required String bookingId,
    required RescheduleBookingRequest request,
  });

  /// Fetch booking timeline entries
  Future<List<BookingTimelineEntry>> fetchBookingTimeline(String bookingId);
}
