import 'package:flutter_bloc/flutter_bloc.dart';
import 'tech_home_event.dart';
import 'tech_home_state.dart';

class TechHomeBloc extends Bloc<TechHomeEvent, TechHomeState> {
  TechHomeBloc() : super(const TechHomeState()) {
    on<TechHomeStarted>(_onStarted);
    on<TechHomeBottomNavChanged>(_onBottomNavChanged);
  }

  void _onStarted(TechHomeStarted event, Emitter<TechHomeState> emit) {
    emit(state.copyWith(status: TechHomeStatus.ready, errorMessage: null));
  }

  void _onBottomNavChanged(
    TechHomeBottomNavChanged event,
    Emitter<TechHomeState> emit,
  ) {
    if (event.index == state.bottomNavIndex) return;
    emit(state.copyWith(bottomNavIndex: event.index));
  }
}
