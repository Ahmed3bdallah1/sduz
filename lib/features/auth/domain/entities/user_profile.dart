import 'package:equatable/equatable.dart';

import '../../../../core/models/json_types.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.raw,
    this.id,
    this.name,
    this.phone,
    this.email,
    this.imageUrl,
    this.title,
    this.bio,
    this.facebookLink,
    this.siteLink,
    this.whatsappNumber,
  });

  final JsonMap raw;
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? imageUrl;
  final String? title;
  final String? bio;
  final String? facebookLink;
  final String? siteLink;
  final String? whatsappNumber;

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        imageUrl,
        title,
        bio,
        facebookLink,
        siteLink,
        whatsappNumber,
        raw,
      ];
}
