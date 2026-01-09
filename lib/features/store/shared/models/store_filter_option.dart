import 'package:equatable/equatable.dart';

class StoreFilterOption extends Equatable {
  final String id;
  final String labelKey;

  const StoreFilterOption({
    required this.id,
    required this.labelKey,
  });

  @override
  List<Object?> get props => [id, labelKey];
}
