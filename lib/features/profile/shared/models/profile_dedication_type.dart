import 'package:equatable/equatable.dart';

class ProfileDedicationType extends Equatable {
  final String id;
  final String title;

  const ProfileDedicationType({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
