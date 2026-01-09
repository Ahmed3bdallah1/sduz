import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/profile/my_packages/bloc/my_packages_event.dart';
import 'package:sudz/features/profile/my_packages/bloc/my_packages_state.dart';
import 'package:sudz/features/profile/my_packages/data/my_packages_repository.dart';

class MyPackagesBloc extends Bloc<MyPackagesEvent, MyPackagesState> {
  final MyPackagesRepository _repository;

  MyPackagesBloc({required MyPackagesRepository repository})
      : _repository = repository,
        super(const MyPackagesState()) {
    on<MyPackagesStarted>(_onStarted);
    on<MyPackageSelected>(_onPackageSelected);
  }

  Future<void> _onStarted(
    MyPackagesStarted event,
    Emitter<MyPackagesState> emit,
  ) async {
    emit(state.copyWith(status: MyPackagesStatus.loading, errorMessage: null));

    try {
      final packages = await _repository.fetchPackages();
      emit(
        state.copyWith(
          status: MyPackagesStatus.success,
          packages: packages,
          selectedPackageId: packages.isNotEmpty ? packages.first.id : null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: MyPackagesStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onPackageSelected(
    MyPackageSelected event,
    Emitter<MyPackagesState> emit,
  ) {
    if (state.packages.any((pkg) => pkg.id == event.packageId)) {
      emit(state.copyWith(selectedPackageId: event.packageId));
    }
  }
}
