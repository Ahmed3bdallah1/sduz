import 'package:equatable/equatable.dart';

enum StorePaymentType { cash, card, provider }

class StorePaymentMethod extends Equatable {
  final String id;
  final String nameKey;
  final String? maskedNumber;
  final StorePaymentType type;
  final bool isDefault;

  const StorePaymentMethod({
    required this.id,
    required this.nameKey,
    this.maskedNumber,
    required this.type,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, nameKey, maskedNumber, type, isDefault];
}
