class CancelBookingRequest {
  const CancelBookingRequest({required this.reason});

  final String reason;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reason': reason,
    };
  }
}
