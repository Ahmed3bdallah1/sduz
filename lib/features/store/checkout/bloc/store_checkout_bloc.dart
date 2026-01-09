import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/store/checkout/bloc/store_checkout_event.dart';
import 'package:sudz/features/store/checkout/bloc/store_checkout_state.dart';
import 'package:sudz/features/store/checkout/data/store_checkout_repository.dart';

class StoreCheckoutBloc
    extends Bloc<StoreCheckoutEvent, StoreCheckoutState> {
  final StoreCheckoutRepository _repository;

  StoreCheckoutBloc({StoreCheckoutRepository? repository})
      : _repository = repository ?? const StoreCheckoutRepository(),
        super(const StoreCheckoutState()) {
    on<StoreCheckoutStarted>(_onStarted);
    on<StoreCheckoutPaymentSelected>(_onPaymentSelected);
  }

  Future<void> _onStarted(
    StoreCheckoutStarted event,
    Emitter<StoreCheckoutState> emit,
  ) async {
    emit(state.copyWith(status: StoreCheckoutStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final methods = _repository.fetchPaymentMethods();
    final defaultMethod = methods.firstWhere(
      (method) => method.isDefault,
      orElse: () => methods.first,
    );

    emit(
      state.copyWith(
        status: StoreCheckoutStatus.success,
        paymentMethods: methods,
        selectedMethodId: defaultMethod.id,
        subtotal: event.total - state.deliveryFee,
        total: event.total,
      ),
    );
  }

  void _onPaymentSelected(
    StoreCheckoutPaymentSelected event,
    Emitter<StoreCheckoutState> emit,
  ) {
    if (state.paymentMethods
        .any((method) => method.id == event.methodId)) {
      emit(state.copyWith(selectedMethodId: event.methodId));
    }
  }
}
