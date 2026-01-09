class RateBookingPayload {
  const RateBookingPayload({
    required this.overallRating,
    required this.qualityScore,
    required this.punctualityScore,
    required this.professionalismScore,
    required this.cleanlinessScore,
    this.reviewText,
    this.reviewTextAr,
    this.tipAmount,
    this.tipPaymentMethod,
  });

  final int overallRating;
  final int qualityScore;
  final int punctualityScore;
  final int professionalismScore;
  final int cleanlinessScore;
  final String? reviewText;
  final String? reviewTextAr;
  final double? tipAmount;
  final String? tipPaymentMethod;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'overall_rating': overallRating,
      'quality_score': qualityScore,
      'punctuality_score': punctualityScore,
      'professionalism_score': professionalismScore,
      'cleanliness_score': cleanlinessScore,
      'review_text': reviewText,
      'review_text_ar': reviewTextAr,
      'tip_amount': tipAmount,
      'tip_payment_method': tipPaymentMethod,
    }..removeWhere((_, value) => value == null);
  }
}
