import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/store/order_confirmation/bloc/store_order_confirmation_event.dart';
import 'package:sudz/features/store/order_confirmation/bloc/store_order_confirmation_state.dart';
import 'package:sudz/features/store/order_confirmation/data/store_order_confirmation_repository.dart';

class StoreOrderConfirmationBloc extends Bloc<StoreOrderConfirmationEvent,
    StoreOrderConfirmationState> {
  final StoreOrderConfirmationRepository _repository;

  StoreOrderConfirmationBloc({StoreOrderConfirmationRepository? repository})
      : _repository = repository ?? const StoreOrderConfirmationRepository(),
        super(const StoreOrderConfirmationState()) {
    on<StoreOrderConfirmationStarted>(_onStarted);
  }

  Future<void> _onStarted(
    StoreOrderConfirmationStarted event,
    Emitter<StoreOrderConfirmationState> emit,
  ) async {
    emit(state.copyWith(status: StoreOrderConfirmationStatus.loading));
    await _repository.confirmOrder();
    emit(state.copyWith(status: StoreOrderConfirmationStatus.success));
  }
}
