import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/core/network/network_exceptions.dart';
import 'package:sudz/features/auth/domain/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(const LoginState()) {
    on<LoginEmailChangedEvent>(_onEmailChanged);
    on<LoginPasswordChangedEvent>(_onPasswordChanged);
    on<LoginTogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<LoginSubmitEvent>(_onSubmit);
  }

  final AuthRepository _authRepository;

  void _onEmailChanged(LoginEmailChangedEvent event, Emitter<LoginState> emit) {
    emit(state.updateEmailOrPhone(event.emailOrPhone));
  }

  void _onPasswordChanged(
    LoginPasswordChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.updatePassword(event.password));
  }

  void _onTogglePasswordVisibility(
    LoginTogglePasswordVisibilityEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.togglePasswordVisibility());
  }

  Future<void> _onSubmit(
    LoginSubmitEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(state.toFailure('auth.login.error_empty_fields'));
      return;
    }

    emit(state.toLoading());

    try {
      await _authRepository.login(
        phone: event.emailOrPhone,
        password: event.password,
      );
      emit(state.toSuccess());
    } on ValidationException catch (e) {
      final firstError = e.fieldErrors.values
          .expand((messages) => messages)
          .firstWhere(
            (message) => message.trim().isNotEmpty,
            orElse: () => e.message,
          );
      emit(state.toFailure(firstError));
    } on UnauthorizedException {
      emit(state.toFailure('auth.login.invalid_credentials'));
    } on AppNetworkException catch (error) {
      emit(state.toFailure(error.message));
    } catch (_) {
      emit(state.toFailure('auth.login.error_message'));
    }
  }
}
