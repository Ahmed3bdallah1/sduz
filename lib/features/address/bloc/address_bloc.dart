import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/user_address.dart';
import '../domain/repositories/address_repository.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this._repository) : super(const AddressState()) {
    on<AddressRequested>(_onRequested);
    on<AddressSelected>(_onSelected);
    on<AddressCreated>(_onCreated);
    on<AddressUpdated>(_onUpdated);
    on<AddressDeleted>(_onDeleted);
    on<AddressSetDefaultRequested>(_onSetDefault);
    on<AddressMutationStatusCleared>(_onMutationCleared);
  }

  final AddressRepository _repository;

  Future<void> _onRequested(
    AddressRequested event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading, clearError: true));

    try {
      final addresses = await _repository.fetchAddresses();
      emit(
        state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          selectedAddress: _deriveSelectedAddress(
            currentId: state.selectedAddress?.id,
            addresses: addresses,
          ),
          overrideSelected: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AddressStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onSelected(AddressSelected event, Emitter<AddressState> emit) {
    if (state.addresses.isEmpty) return;
    final selected = state.addresses.firstWhere(
      (address) => address.id == event.addressId,
      orElse: () => state.selectedAddress ?? state.addresses.first,
    );

    emit(state.copyWith(selectedAddress: selected, overrideSelected: true));
  }

  Future<void> _onCreated(
    AddressCreated event,
    Emitter<AddressState> emit,
  ) async {
    await _mutate(
      emit,
      type: AddressMutationType.create,
      action: () => _repository.createAddress(event.payload),
    );
  }

  Future<void> _onUpdated(
    AddressUpdated event,
    Emitter<AddressState> emit,
  ) async {
    await _mutate(
      emit,
      type: AddressMutationType.update,
      action: () =>
          _repository.updateAddress(id: event.id, payload: event.payload),
      touchedId: event.id,
    );
  }

  Future<void> _onDeleted(
    AddressDeleted event,
    Emitter<AddressState> emit,
  ) async {
    await _mutate(
      emit,
      type: AddressMutationType.delete,
      action: () async {
        await _repository.deleteAddress(event.id);
        return null;
      },
      touchedId: event.id,
    );
  }

  Future<void> _onSetDefault(
    AddressSetDefaultRequested event,
    Emitter<AddressState> emit,
  ) async {
    await _mutate(
      emit,
      type: AddressMutationType.setDefault,
      action: () => _repository.setDefault(event.id),
      touchedId: event.id,
    );
  }

  void _onMutationCleared(
    AddressMutationStatusCleared event,
    Emitter<AddressState> emit,
  ) {
    emit(
      state.copyWith(
        mutationStatus: AddressMutationStatus.idle,
        mutationType: AddressMutationType.none,
        mutationError: null,
      ),
    );
  }

  Future<void> _mutate(
    Emitter<AddressState> emit, {
    required AddressMutationType type,
    required Future<UserAddress?> Function() action,
    String? touchedId,
  }) async {
    emit(
      state.copyWith(
        mutationStatus: AddressMutationStatus.inProgress,
        mutationType: type,
        clearMutationError: true,
      ),
    );

    try {
      final result = await action();
      late final List<UserAddress> updatedList;

      switch (type) {
        case AddressMutationType.create:
          updatedList = _insertAddress(state.addresses, result!);
          break;
        case AddressMutationType.update:
        case AddressMutationType.setDefault:
          updatedList = _upsertAddress(state.addresses, result!, touchedId);
          break;
        case AddressMutationType.delete:
          updatedList = state.addresses
              .where((address) => address.id != touchedId)
              .toList(growable: false);
          break;
        case AddressMutationType.none:
          updatedList = state.addresses;
          break;
      }

      emit(
        state.copyWith(
          mutationStatus: AddressMutationStatus.success,
          addresses: updatedList,
          selectedAddress: _deriveSelectedAddress(
            currentId: state.selectedAddress?.id,
            addresses: updatedList,
          ),
          overrideSelected: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          mutationStatus: AddressMutationStatus.failure,
          mutationError: error.toString(),
        ),
      );
    }
  }

  List<UserAddress> _upsertAddress(
    List<UserAddress> current,
    UserAddress updated,
    String? touchedId,
  ) {
    final mapped = current
        .map((address) {
          final shouldReplace =
              address.id == updated.id ||
              (touchedId != null && address.id == touchedId);
          if (shouldReplace) {
            return updated;
          }
          if (updated.isDefault) {
            return address.copyWith(isDefault: false);
          }
          return address;
        })
        .toList(growable: false);

    final exists = mapped.any((element) => element.id == updated.id);
    if (!exists) {
      return [updated, ...mapped];
    }
    return mapped;
  }

  List<UserAddress> _insertAddress(
    List<UserAddress> current,
    UserAddress created,
  ) {
    final normalized = created.isDefault
        ? current.map((address) => address.copyWith(isDefault: false)).toList()
        : List<UserAddress>.from(current);
    return [created, ...normalized];
  }

  UserAddress? _deriveSelectedAddress({
    required String? currentId,
    required List<UserAddress> addresses,
  }) {
    if (addresses.isEmpty) return null;
    if (currentId != null) {
      final existing = addresses.firstWhere(
        (address) => address.id == currentId,
        orElse: () => addresses.first,
      );
      if (existing.id == currentId) return existing;
    }
    final defaultAddress = addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => addresses.first,
    );
    return defaultAddress;
  }
}
