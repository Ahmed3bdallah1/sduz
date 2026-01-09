class SpecialTimeRequestPayload {
  const SpecialTimeRequestPayload({
    required this.serviceId,
    required this.addressId,
    required this.requestedDate,
    required this.requestedStartTime,
    required this.requestedEndTime,
    this.reason,
  });

  final String serviceId;
  final String addressId;
  final String requestedDate;
  final String requestedStartTime;
  final String requestedEndTime;
  final String? reason;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'service_id': serviceId,
      'address_id': addressId,
      'requested_date': requestedDate,
      'requested_start_time': requestedStartTime,
      'requested_end_time': requestedEndTime,
      'reason': reason,
    }..removeWhere((_, value) => value == null);
  }
}
