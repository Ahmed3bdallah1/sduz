import '../../../../core/models/json_types.dart';

class CreateBookingRequest {
  const CreateBookingRequest({
    required this.serviceId,
    required this.carId,
    required this.addressId,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.paymentMethod,
    required this.totalAmount,
    this.notes,
  });

  final String serviceId;
  final String carId;
  final String addressId;
  final String scheduledDate;
  final String scheduledStartTime;
  final String scheduledEndTime;
  final String paymentMethod;
  final double totalAmount;
  final String? notes;

  JsonMap toJson() {
    return <String, dynamic>{
      'service_id': serviceId,
      'car_id': carId,
      'address_id': addressId,
      'scheduled_date': scheduledDate,
      'scheduled_start_time': scheduledStartTime,
      'scheduled_end_time': scheduledEndTime,
      'payment_method': paymentMethod,
      'total_amount': totalAmount,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

