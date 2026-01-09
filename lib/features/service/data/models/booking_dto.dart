import '../../../../core/models/json_types.dart';
import '../../domain/entities/booking.dart';

class BookingDto {
  const BookingDto({
    required this.id,
    required this.serviceId,
    required this.carId,
    required this.addressId,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.paymentMethod,
    required this.totalAmount,
    required this.status,
    this.serviceName,
    this.carName,
    this.addressDetails,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String serviceId;
  final String carId;
  final String addressId;
  final String scheduledDate;
  final String scheduledStartTime;
  final String scheduledEndTime;
  final String paymentMethod;
  final double totalAmount;
  final String status;
  final String? serviceName;
  final String? carName;
  final String? addressDetails;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory BookingDto.fromJson(JsonMap json) {
    return BookingDto(
      id: _stringify(json['id'] ?? json['uuid']) ?? '',
      serviceId: _stringify(json['service_id']) ?? '',
      carId: _stringify(json['car_id']) ?? '',
      addressId: _stringify(json['address_id']) ?? '',
      scheduledDate: _stringify(json['scheduled_date']) ?? '',
      scheduledStartTime: _stringify(json['scheduled_start_time']) ?? '',
      scheduledEndTime: _stringify(json['scheduled_end_time']) ?? '',
      paymentMethod: _stringify(json['payment_method']) ?? '',
      totalAmount: _toDouble(json['total_amount']) ?? 0.0,
      status: _stringify(json['status']) ?? 'pending',
      serviceName: _stringify(json['service_name']),
      carName: _stringify(json['car_name']),
      addressDetails: _stringify(json['address_details']),
      notes: _stringify(json['notes']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  JsonMap toJson() {
    return <String, dynamic>{
      'id': id,
      'service_id': serviceId,
      'car_id': carId,
      'address_id': addressId,
      'scheduled_date': scheduledDate,
      'scheduled_start_time': scheduledStartTime,
      'scheduled_end_time': scheduledEndTime,
      'payment_method': paymentMethod,
      'total_amount': totalAmount,
      'status': status,
      'service_name': serviceName,
      'car_name': carName,
      'address_details': addressDetails,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  Booking toEntity() {
    return Booking(
      id: id,
      serviceId: serviceId,
      carId: carId,
      addressId: addressId,
      scheduledDate: scheduledDate,
      scheduledStartTime: scheduledStartTime,
      scheduledEndTime: scheduledEndTime,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      status: status,
      serviceName: serviceName,
      carName: carName,
      addressDetails: addressDetails,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim().isEmpty ? null : value.trim();
    }
    return value.toString();
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

