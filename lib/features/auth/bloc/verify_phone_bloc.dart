import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sudz/core/network/network_exceptions.dart';
import 'package:sudz/features/auth/domain/repositories/auth_repository.dart';

import 'verify_phone_event.dart';
import 'verify_phone_state.dart';

class VerifyPhoneBloc extends Bloc<VerifyPhoneEvent, VerifyPhoneState> {
  VerifyPhoneBloc({
    required AuthRepository authRepository,
    required String phone,
  })  : _authRepository = authRepository,
        super(VerifyPhoneState(phone: phone)) {
    on<VerifyPhoneCodeChangedEvent>(_onCodeChanged);
    on<VerifyPhoneSubmittedEvent>(_onSubmit);
  }

  final AuthRepository _authRepository;

  void _onCodeChanged(
    VerifyPhoneCodeChangedEvent event,
    Emitter<VerifyPhoneState> emit,
  ) {
    final sanitizedCode = event.code.replaceAll(RegExp(r'[^0-9]'), '');
    final updatedErrors = Map<String, List<String>>.from(state.fieldErrors)
      ..remove('code');
    emit(
      state.copyWith(
        code: sanitizedCode,
        fieldErrors: updatedErrors,
        errorMessage: null,
        clearResult: true,
      ),
    );
  }

  Future<void> _onSubmit(
    VerifyPhoneSubmittedEvent event,
    Emitter<VerifyPhoneState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: VerifyPhoneStatus.failure,
          errorMessage: 'auth.verify_phone.code_length_error',
          clearResult: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: VerifyPhoneStatus.loading,
        errorMessage: null,
        fieldErrors: const <String, List<String>>{},
        clearResult: true,
      ),
    );

    try {
      final result = await _authRepository.verifyPhone(
        phone: state.phone,
        code: state.code,
      );
      emit(
        state.copyWith(
          status: VerifyPhoneStatus.success,
          result: result,
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
          status: VerifyPhoneStatus.failure,
          fieldErrors: e.fieldErrors,
          errorMessage: firstError,
          clearResult: true,
        ),
      );
    } on UnauthorizedException catch (e) {
      final message = _extractMessage(e.details, e.message);
      emit(
        state.copyWith(
          status: VerifyPhoneStatus.failure,
          errorMessage: message,
          clearResult: true,
        ),
      );
    } on AppNetworkException catch (error) {
      final message = _extractMessage(error.details, error.message);
      emit(
        state.copyWith(
          status: VerifyPhoneStatus.failure,
          errorMessage: message,
          clearResult: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: VerifyPhoneStatus.failure,
          errorMessage: 'auth.verify_phone.generic_error',
          clearResult: true,
        ),
      );
    }
  }
}

String _extractMessage(dynamic details, String fallback) {
  if (details is Map<String, dynamic>) {
    final message = details['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  return fallback;
}
