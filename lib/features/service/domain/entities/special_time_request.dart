import 'package:equatable/equatable.dart';

class SpecialTimeRequest extends Equatable {
  const SpecialTimeRequest({
    required this.id,
    required this.serviceId,
    required this.addressId,
    required this.requestedDate,
    required this.requestedStartTime,
    required this.requestedEndTime,
    required this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String serviceId;
  final String addressId;
  final String requestedDate;
  final String requestedStartTime;
  final String requestedEndTime;
  final String status;
  final String? reason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        serviceId,
        addressId,
        requestedDate,
        requestedStartTime,
        requestedEndTime,
        status,
        reason,
        createdAt,
        updatedAt,
      ];
}
