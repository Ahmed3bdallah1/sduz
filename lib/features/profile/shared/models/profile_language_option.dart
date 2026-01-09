import 'package:equatable/equatable.dart';

class ProfileLanguageOption extends Equatable {
  final String code;
  final String labelKey;

  const ProfileLanguageOption({required this.code, required this.labelKey});

  @override
  List<Object?> get props => [code, labelKey];
}
