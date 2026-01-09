import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  const Rating({
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

  @override
  List<Object?> get props => [
        id,
        bookingId,
        overallRating,
        qualityScore,
        punctualityScore,
        professionalismScore,
        cleanlinessScore,
        reviewText,
        reviewTextAr,
        tipAmount,
        tipPaymentMethod,
        note,
        createdAt,
      ];
}
