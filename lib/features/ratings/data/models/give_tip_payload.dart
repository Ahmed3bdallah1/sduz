class GiveTipPayload {
  const GiveTipPayload({
    required this.tipAmount,
    required this.paymentMethod,
    this.note,
  });

  final double tipAmount;
  final String paymentMethod;
  final String? note;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tip_amount': tipAmount,
      'payment_method': paymentMethod,
      'note': note,
    }..removeWhere((_, value) => value == null);
  }
}
