import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/store/home/data/store_home_repository.dart';
import 'store_home_event.dart';
import 'store_home_state.dart';

class StoreHomeBloc extends Bloc<StoreHomeEvent, StoreHomeState> {
  final StoreHomeRepository _repository;

  StoreHomeBloc({StoreHomeRepository? repository})
      : _repository = repository ?? const StoreHomeRepository(),
        super(const StoreHomeState()) {
    on<StoreHomeStarted>(_onStarted);
  }

  Future<void> _onStarted(
    StoreHomeStarted event,
    Emitter<StoreHomeState> emit,
  ) async {
    emit(state.copyWith(status: StoreHomeStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    emit(
      state.copyWith(
        status: StoreHomeStatus.success,
        categories: _repository.fetchCategories(),
        errorMessage: null,
      ),
    );
  }
}
