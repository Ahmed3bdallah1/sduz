import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sudz/core/network/network_exceptions.dart';
import 'package:sudz/features/auth/domain/repositories/auth_repository.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(this._authRepository) : super(const SignupState()) {
    on<SignupNameChangedEvent>(_onNameChanged);
    on<SignupPhoneNumberChangedEvent>(_onPhoneNumberChanged);
    on<SignupEmailChangedEvent>(_onEmailChanged);
    on<SignupPasswordChangedEvent>(_onPasswordChanged);
    on<SignupTogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<SignupSubmitEvent>(_onSubmit);
  }

  final AuthRepository _authRepository;

  void _onNameChanged(SignupNameChangedEvent event, Emitter<SignupState> emit) {
    final updatedErrors = Map<String, List<String>>.from(state.fieldErrors)
      ..remove('name');
    emit(
      state.copyWith(
        name: event.name,
        fieldErrors: updatedErrors,
        errorMessage: null,
        clearResult: true,
      ),
    );
  }

  void _onPhoneNumberChanged(
    SignupPhoneNumberChangedEvent event,
    Emitter<SignupState> emit,
  ) {
    final updatedErrors = Map<String, List<String>>.from(state.fieldErrors)
      ..remove('phone');
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        fieldErrors: updatedErrors,
        errorMessage: null,
        clearResult: true,
      ),
    );
  }

  void _onEmailChanged(
    SignupEmailChangedEvent event,
    Emitter<SignupState> emit,
  ) {
    final updatedErrors = Map<String, List<String>>.from(state.fieldErrors)
      ..remove('email');
    emit(
      state.copyWith(
        email: event.email,
        fieldErrors: updatedErrors,
        errorMessage: null,
        clearResult: true,
      ),
    );
  }

  void _onPasswordChanged(
    SignupPasswordChangedEvent event,
    Emitter<SignupState> emit,
  ) {
    final updatedErrors = Map<String, List<String>>.from(state.fieldErrors)
      ..remove('password');
    emit(
      state.copyWith(
        password: event.password,
        fieldErrors: updatedErrors,
        errorMessage: null,
        clearResult: true,
      ),
    );
  }

  void _onTogglePasswordVisibility(
    SignupTogglePasswordVisibilityEvent event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSubmit(
    SignupSubmitEvent event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: 'auth.signup.error_empty_fields',
          clearResult: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SignupStatus.loading,
        errorMessage: null,
        fieldErrors: const <String, List<String>>{},
        clearResult: true,
      ),
    );

    try {
      final result = await _authRepository.register(
        name: event.name.trim(),
        phone: event.phoneNumber.trim(),
        email: event.email.trim(),
        password: event.password,
        passwordConfirmation: event.password,
      );

      emit(
        state.copyWith(
          status: SignupStatus.success,
          result: result,
          fieldErrors: const <String, List<String>>{},
        ),
      );
    } on ValidationException catch (e) {
      final firstError = e.fieldErrors.values
          .expand((messages) => messages)
          .firstWhere(
            (message) => message.trim().isNotEmpty,
            orElse: () => e.message,
          );
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          fieldErrors: e.fieldErrors,
          errorMessage: firstError,
          clearResult: true,
        ),
      );
    } on AppNetworkException catch (error) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: error.message,
          clearResult: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: 'auth.signup.error_message',
          clearResult: true,
        ),
      );
    }
  }
}
