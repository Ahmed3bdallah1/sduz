import '../../../../core/models/json_types.dart';
import '../../domain/entities/rating.dart';

class RatingDto {
  const RatingDto({
    required this.id,
    required this.bookingId,
    required this.overallRating,
    this.qualityScore,
    this.punctualityScore,
    this.professionalismScore,
    this.cleanlinessScore,
    this.reviewText,
    this.reviewTextAr,
    this.tipAmount,
    this.tipPaymentMethod,
    this.note,
    this.createdAt,
  });

  final String id;
  final String bookingId;
  final int overallRating;
  final int? qualityScore;
  final int? punctualityScore;
  final int? professionalismScore;
  final int? cleanlinessScore;
  final String? reviewText;
  final String? reviewTextAr;
  final double? tipAmount;
  final String? tipPaymentMethod;
  final String? note;
  final DateTime? createdAt;

  factory RatingDto.fromJson(JsonMap json) {
    return RatingDto(
      id: _stringify(json['id'] ?? json['uuid']) ?? '',
      bookingId: _stringify(json['booking_id']) ?? '',
      overallRating: _toInt(json['overall_rating']) ?? 0,
      qualityScore: _toInt(json['quality_score']),
      punctualityScore: _toInt(json['punctuality_score']),
      professionalismScore: _toInt(json['professionalism_score']),
      cleanlinessScore: _toInt(json['cleanliness_score']),
      reviewText: _stringify(json['review_text']),
      reviewTextAr: _stringify(json['review_text_ar']),
      tipAmount: _toDouble(json['tip_amount']),
      tipPaymentMethod: _stringify(
        json['tip_payment_method'] ?? json['payment_method'],
      ),
      note: _stringify(json['note']),
      createdAt: _toDate(json['created_at']),
    );
  }

  Rating toEntity() {
    return Rating(
      id: id,
      bookingId: bookingId,
      overallRating: overallRating,
      qualityScore: qualityScore,
      punctualityScore: punctualityScore,
      professionalismScore: professionalismScore,
      cleanlinessScore: cleanlinessScore,
      reviewText: reviewText,
      reviewTextAr: reviewTextAr,
      tipAmount: tipAmount,
      tipPaymentMethod: tipPaymentMethod,
      note: note,
      createdAt: createdAt,
    );
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim().isEmpty ? null : value.trim();
    }
    return value.toString();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }
}
