import 'package:equatable/equatable.dart';

import '../data/models/address_payload.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class AddressRequested extends AddressEvent {
  const AddressRequested();
}

class AddressSelected extends AddressEvent {
  const AddressSelected(this.addressId);

  final String addressId;

  @override
  List<Object?> get props => [addressId];
}

class AddressCreated extends AddressEvent {
  const AddressCreated(this.payload);

  final AddressPayload payload;

  @override
  List<Object?> get props => [payload];
}

class AddressUpdated extends AddressEvent {
  const AddressUpdated({required this.id, required this.payload});

  final String id;
  final AddressPayload payload;

  @override
  List<Object?> get props => [id, payload];
}

class AddressDeleted extends AddressEvent {
  const AddressDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class AddressSetDefaultRequested extends AddressEvent {
  const AddressSetDefaultRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class AddressMutationStatusCleared extends AddressEvent {
  const AddressMutationStatusCleared();
}
