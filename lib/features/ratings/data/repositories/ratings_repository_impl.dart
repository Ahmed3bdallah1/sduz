import '../../domain/entities/rating.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../datasources/ratings_remote_data_source.dart';
import '../models/give_tip_payload.dart';
import '../models/rate_booking_payload.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  RatingsRepositoryImpl(this._remoteDataSource);

  final RatingsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Rating>> fetchMyRatings() async {
    final dtos = await _remoteDataSource.fetchMyRatings();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<Rating> rateBooking({
    required String bookingId,
    required RateBookingPayload payload,
  }) async {
    final dto = await _remoteDataSource.rateBooking(
      bookingId: bookingId,
      payload: payload,
    );
    return dto.toEntity();
  }

  @override
  Future<Rating> giveTip({
    required String bookingId,
    required GiveTipPayload payload,
  }) async {
    final dto = await _remoteDataSource.giveTip(
      bookingId: bookingId,
      payload: payload,
    );
    return dto.toEntity();
  }
}
