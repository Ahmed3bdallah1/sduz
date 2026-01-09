import '../../../../core/models/json_types.dart';
import '../../domain/entities/special_time_request.dart';

class SpecialTimeRequestDto {
  const SpecialTimeRequestDto({
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

  factory SpecialTimeRequestDto.fromJson(JsonMap json) {
    return SpecialTimeRequestDto(
      id: _stringify(json['id'] ?? json['uuid']) ?? '',
      serviceId: _stringify(json['service_id']) ?? '',
      addressId: _stringify(json['address_id']) ?? '',
      requestedDate: _stringify(json['requested_date']) ?? '',
      requestedStartTime: _stringify(json['requested_start_time']) ?? '',
      requestedEndTime: _stringify(json['requested_end_time']) ?? '',
      status: _stringify(json['status']) ?? 'pending',
      reason: _stringify(json['reason']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  SpecialTimeRequest toEntity() {
    return SpecialTimeRequest(
      id: id,
      serviceId: serviceId,
      addressId: addressId,
      requestedDate: requestedDate,
      requestedStartTime: requestedStartTime,
      requestedEndTime: requestedEndTime,
      status: status,
      reason: reason,
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

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }
}
