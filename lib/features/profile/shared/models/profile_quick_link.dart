import 'package:equatable/equatable.dart';

class ProfileQuickLink extends Equatable {
  const ProfileQuickLink({
    required this.id,
    required this.titleKey,
    required this.iconAsset,
  });

  final String id;
  final String titleKey;
  final String iconAsset;

  @override
  List<Object?> get props => [id, titleKey, iconAsset];
}
