class RescheduleBookingRequest {
  const RescheduleBookingRequest({
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
  });

  final String scheduledDate;
  final String scheduledStartTime;
  final String scheduledEndTime;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'scheduled_date': scheduledDate,
      'scheduled_start_time': scheduledStartTime,
      'scheduled_end_time': scheduledEndTime,
    };
  }
}
