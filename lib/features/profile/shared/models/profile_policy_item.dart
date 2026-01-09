import 'package:equatable/equatable.dart';

class ProfilePolicyItem extends Equatable {
  final String id;
  final String titleKey;
  final String iconAsset;

  const ProfilePolicyItem({
    required this.id,
    required this.titleKey,
    required this.iconAsset,
  });

  @override
  List<Object?> get props => [id, titleKey, iconAsset];
}
