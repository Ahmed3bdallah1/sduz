import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/profile/home/bloc/profile_home_event.dart';
import 'package:sudz/features/profile/home/bloc/profile_home_state.dart';
import 'package:sudz/features/profile/home/data/profile_home_repository.dart';

class ProfileHomeBloc extends Bloc<ProfileHomeEvent, ProfileHomeState> {
  final ProfileHomeRepository _repository;

  ProfileHomeBloc({ProfileHomeRepository? repository})
    : _repository = repository ?? const ProfileHomeRepository(),
      super(const ProfileHomeState()) {
    on<ProfileHomeStarted>(_onStarted);
    on<ProfileLanguageToggled>(_onLanguageToggled);
  }

  Future<void> _onStarted(
    ProfileHomeStarted event,
    Emitter<ProfileHomeState> emit,
  ) async {
    emit(state.copyWith(status: ProfileHomeStatus.loading));
    await Future<void>.delayed(const Duration(milliseconds: 200));

    try {
      final name = _repository.fetchUserName();
      final links = _repository.fetchQuickLinks();
      final policies = _repository.fetchPolicyItems();
      final languages = _repository.fetchLanguageOptions();

      emit(
        state.copyWith(
          status: ProfileHomeStatus.success,
          userName: name,
          quickLinks: links,
          policies: policies,
          languages: languages,
          selectedLanguageCode: languages.isNotEmpty
              ? languages.first.code
              : 'ar',
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileHomeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onLanguageToggled(
    ProfileLanguageToggled event,
    Emitter<ProfileHomeState> emit,
  ) {
    if (state.languages.any((language) => language.code == event.code)) {
      emit(state.copyWith(selectedLanguageCode: event.code));
    }
  }
}
