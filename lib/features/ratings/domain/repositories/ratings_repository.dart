import '../entities/rating.dart';
import '../../data/models/give_tip_payload.dart';
import '../../data/models/rate_booking_payload.dart';

abstract class RatingsRepository {
  Future<List<Rating>> fetchMyRatings();

  Future<Rating> rateBooking({
    required String bookingId,
    required RateBookingPayload payload,
  });

  Future<Rating> giveTip({
    required String bookingId,
    required GiveTipPayload payload,
  });
}
