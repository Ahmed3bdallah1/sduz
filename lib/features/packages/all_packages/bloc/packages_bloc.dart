import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/packages/all_packages/bloc/packages_event.dart';
import 'package:sudz/features/packages/all_packages/bloc/packages_state.dart';
import 'package:sudz/features/packages/domain/repositories/packages_repository.dart';

class PackagesBloc extends Bloc<PackagesEvent, PackagesState> {
  final PackagesRepository _repository;

  PackagesBloc({required PackagesRepository repository})
    : _repository = repository,
      super(const PackagesState()) {
    on<PackagesStarted>(_onStarted);
    on<PackageSelectionChanged>(_onSelectionChanged);
  }

  Future<void> _onStarted(
    PackagesStarted event,
    Emitter<PackagesState> emit,
  ) async {
    emit(state.copyWith(status: PackagesStatus.loading, errorMessage: null));

    try {
      final packages = await _repository.fetchPackages();
      emit(
        state.copyWith(
          status: PackagesStatus.success,
          packages: packages,
          selectedPackageId: packages.isNotEmpty ? packages.first.id : null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PackagesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onSelectionChanged(
    PackageSelectionChanged event,
    Emitter<PackagesState> emit,
  ) {
    if (state.packages.any((pkg) => pkg.id == event.packageId)) {
      emit(state.copyWith(selectedPackageId: event.packageId));
    }
  }
}
