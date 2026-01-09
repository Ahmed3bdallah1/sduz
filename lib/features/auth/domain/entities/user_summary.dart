import 'package:equatable/equatable.dart';

import '../../../../core/models/json_types.dart';

class UserSummary extends Equatable {
  const UserSummary({
    required this.raw,
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    this.isVerified,
    this.role,
    this.imageUrl,
  });

  final JsonMap raw;
  final int id;
  final String name;
  final String phone;
  final String email;
  final bool status;
  final bool? isVerified;
  final String? role;
  final String? imageUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        status,
        isVerified,
        role,
        imageUrl,
        raw,
      ];
}
