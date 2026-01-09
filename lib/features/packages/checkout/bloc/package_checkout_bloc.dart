import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/packages/checkout/bloc/package_checkout_event.dart';
import 'package:sudz/features/packages/checkout/bloc/package_checkout_state.dart';
import 'package:sudz/features/packages/checkout/data/package_checkout_repository.dart';
import 'package:sudz/features/packages/domain/repositories/packages_repository.dart';

class PackageCheckoutBloc
    extends Bloc<PackageCheckoutEvent, PackageCheckoutState> {
  final PackageCheckoutRepository _checkoutRepository;
  final PackagesRepository _packagesRepository;

  PackageCheckoutBloc({
    PackageCheckoutRepository? checkoutRepository,
    required PackagesRepository packagesRepository,
  })  : _checkoutRepository =
            checkoutRepository ?? const PackageCheckoutRepository(),
        _packagesRepository = packagesRepository,
        super(const PackageCheckoutState()) {
    on<PackageCheckoutStarted>(_onStarted);
    on<PackageCheckoutPaymentSelected>(_onPaymentSelected);
    on<PackageCheckoutSubmitted>(_onSubmitted);
  }

  Future<void> _onStarted(
    PackageCheckoutStarted event,
    Emitter<PackageCheckoutState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PackageCheckoutStatus.loading,
        package: event.package,
        errorMessage: null,
      ),
    );

    try {
      final methods = _checkoutRepository.fetchPaymentMethods();
      final defaultMethod = methods.firstWhere(
        (method) => method.isDefault,
        orElse: () => methods.first,
      );

      emit(
        state.copyWith(
          status: PackageCheckoutStatus.ready,
          paymentMethods: methods,
          selectedMethodId: defaultMethod.id,
          subtotal: event.package.price,
          deliveryFee: 0,
          total: event.package.price,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PackageCheckoutStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onPaymentSelected(
    PackageCheckoutPaymentSelected event,
    Emitter<PackageCheckoutState> emit,
  ) {
    if (state.paymentMethods.any((method) => method.id == event.methodId)) {
      emit(state.copyWith(selectedMethodId: event.methodId));
    }
  }

  Future<void> _onSubmitted(
    PackageCheckoutSubmitted event,
    Emitter<PackageCheckoutState> emit,
  ) async {
    if (state.package == null || state.selectedMethodId == null) {
      return;
    }

    emit(
      state.copyWith(
        status: PackageCheckoutStatus.processing,
        errorMessage: null,
      ),
    );

    try {
      // Find the actual payment method key (e.g., 'cod', 'card', etc.)
      final selectedMethod = state.paymentMethods
          .firstWhere((method) => method.id == state.selectedMethodId);
      
      final userPackage = await _packagesRepository.purchasePackage(
        packageId: state.package!.id,
        paymentMethod: selectedMethod.id,
      );

      emit(state.copyWith(
        status: PackageCheckoutStatus.success,
        purchasedPackageId: userPackage.id,
      ));
    } catch (error) {
      emit(
        state.copyWith(
          status: PackageCheckoutStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
