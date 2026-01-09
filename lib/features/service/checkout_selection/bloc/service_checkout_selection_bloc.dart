import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sudz/features/service/checkout_selection/models/models.dart';
import 'service_checkout_selection_event.dart';
import 'service_checkout_selection_state.dart';

class ServiceCheckoutSelectionBloc
    extends Bloc<ServiceCheckoutSelectionEvent, ServiceCheckoutSelectionState> {
  ServiceCheckoutSelectionBloc({required ServiceCheckoutSelectionParams params})
    : super(
        ServiceCheckoutSelectionState(
          status: ServiceCheckoutSelectionStatus.initial,
          serviceType: params.serviceType,
          car: params.car,
          package: params.activePackage,
          schedule: params.scheduleSelection,
        ),
      ) {
    on<ServiceCheckoutSelectionStarted>(_onStarted);
    on<ServiceCheckoutOptionChanged>(_onOptionChanged);
    on<ServiceCheckoutContinuePressed>(_onContinuePressed);
    on<ServiceCheckoutNavigationHandled>(_onNavigationHandled);

    add(const ServiceCheckoutSelectionStarted());
  }

  void _onStarted(
    ServiceCheckoutSelectionStarted event,
    Emitter<ServiceCheckoutSelectionState> emit,
  ) {
    final defaultOption = state.hasAvailablePackage
        ? ServiceCheckoutOption.package
        : ServiceCheckoutOption.singleService;

    emit(
      state.copyWith(
        status: ServiceCheckoutSelectionStatus.ready,
        selectedOption: defaultOption,
        overrideSelectedOption: true,
        showValidationError: false,
        overrideNextStep: true,
        nextStep: null,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onOptionChanged(
    ServiceCheckoutOptionChanged event,
    Emitter<ServiceCheckoutSelectionState> emit,
  ) {
    if (event.option == ServiceCheckoutOption.package &&
        !state.hasAvailablePackage) {
      // Prevent selecting a package if none are available.
      emit(
        state.copyWith(
          showValidationError: true,
          errorMessage: 'service.checkout.error_no_package',
          overrideErrorMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedOption: event.option,
        overrideSelectedOption: true,
        showValidationError: false,
        overrideNextStep: true,
        nextStep: null,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onContinuePressed(
    ServiceCheckoutContinuePressed event,
    Emitter<ServiceCheckoutSelectionState> emit,
  ) {
    if (!state.canSubmit) {
      emit(
        state.copyWith(
          showValidationError: true,
          errorMessage: 'service.checkout.error_choose_option',
          overrideErrorMessage: true,
        ),
      );
      return;
    }

    final nextStep = state.selectedOption == ServiceCheckoutOption.package
        ? ServiceCheckoutNextStep.package
        : ServiceCheckoutNextStep.singleService;

    emit(
      state.copyWith(
        showValidationError: false,
        nextStep: nextStep,
        overrideNextStep: true,
        errorMessage: null,
        overrideErrorMessage: true,
      ),
    );
  }

  void _onNavigationHandled(
    ServiceCheckoutNavigationHandled event,
    Emitter<ServiceCheckoutSelectionState> emit,
  ) {
    if (state.nextStep == null) return;

    emit(state.copyWith(overrideNextStep: true, nextStep: null));
  }
}
