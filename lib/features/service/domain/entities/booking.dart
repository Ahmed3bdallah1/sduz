import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  const Booking({
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

  Booking copyWith({
    String? id,
    String? serviceId,
    String? carId,
    String? addressId,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduledEndTime,
    String? paymentMethod,
    double? totalAmount,
    String? status,
    String? serviceName,
    String? carName,
    String? addressDetails,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      carId: carId ?? this.carId,
      addressId: addressId ?? this.addressId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      scheduledEndTime: scheduledEndTime ?? this.scheduledEndTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      serviceName: serviceName ?? this.serviceName,
      carName: carName ?? this.carName,
      addressDetails: addressDetails ?? this.addressDetails,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceId,
        carId,
        addressId,
        scheduledDate,
        scheduledStartTime,
        scheduledEndTime,
        paymentMethod,
        totalAmount,
        status,
        serviceName,
        carName,
        addressDetails,
        notes,
        createdAt,
        updatedAt,
      ];
}

