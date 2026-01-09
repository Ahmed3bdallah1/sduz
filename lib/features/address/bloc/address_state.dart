import 'package:equatable/equatable.dart';

import '../domain/entities/user_address.dart';

enum AddressStatus { initial, loading, success, failure }

enum AddressMutationStatus { idle, inProgress, success, failure }

enum AddressMutationType { none, create, update, delete, setDefault }

class AddressState extends Equatable {
  const AddressState({
    this.status = AddressStatus.initial,
    this.mutationStatus = AddressMutationStatus.idle,
    this.mutationType = AddressMutationType.none,
    this.addresses = const [],
    this.selectedAddress,
    this.errorMessage,
    this.mutationError,
  });

  final AddressStatus status;
  final AddressMutationStatus mutationStatus;
  final AddressMutationType mutationType;
  final List<UserAddress> addresses;
  final UserAddress? selectedAddress;
  final String? errorMessage;
  final String? mutationError;

  bool get isLoading => status == AddressStatus.loading;
  bool get isMutationInProgress =>
      mutationStatus == AddressMutationStatus.inProgress;

  AddressState copyWith({
    AddressStatus? status,
    AddressMutationStatus? mutationStatus,
    AddressMutationType? mutationType,
    List<UserAddress>? addresses,
    UserAddress? selectedAddress,
    bool overrideSelected = false,
    String? errorMessage,
    bool clearError = false,
    String? mutationError,
    bool clearMutationError = false,
  }) {
    return AddressState(
      status: status ?? this.status,
      mutationStatus: mutationStatus ?? this.mutationStatus,
      mutationType: mutationType ?? this.mutationType,
      addresses: addresses ?? this.addresses,
      selectedAddress: overrideSelected
          ? selectedAddress
          : (selectedAddress ?? this.selectedAddress),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      mutationError: clearMutationError
          ? null
          : (mutationError ?? this.mutationError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    mutationStatus,
    mutationType,
    addresses,
    selectedAddress,
    errorMessage,
    mutationError,
  ];
}
