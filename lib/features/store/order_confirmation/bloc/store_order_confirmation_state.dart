import 'package:equatable/equatable.dart';

enum StoreOrderConfirmationStatus { initial, loading, success }

extension StoreOrderConfirmationStatusX on StoreOrderConfirmationStatus {
  bool get isInitial => this == StoreOrderConfirmationStatus.initial;
  bool get isLoading => this == StoreOrderConfirmationStatus.loading;
  bool get isSuccess => this == StoreOrderConfirmationStatus.success;
}

class StoreOrderConfirmationState extends Equatable {
  final StoreOrderConfirmationStatus status;

  const StoreOrderConfirmationState({
    this.status = StoreOrderConfirmationStatus.initial,
  });

  StoreOrderConfirmationState copyWith({
    StoreOrderConfirmationStatus? status,
  }) {
    return StoreOrderConfirmationState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
