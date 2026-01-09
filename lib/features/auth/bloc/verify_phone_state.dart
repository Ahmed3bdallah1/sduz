import 'package:equatable/equatable.dart';

import 'package:sudz/features/auth/domain/entities/verify_phone_result.dart';

enum VerifyPhoneStatus { initial, loading, success, failure }

class VerifyPhoneState extends Equatable {
  const VerifyPhoneState({
    required this.phone,
    this.status = VerifyPhoneStatus.initial,
    this.code = '',
    this.errorMessage,
    this.fieldErrors = const <String, List<String>>{},
    this.result,
  });

  final String phone;
  final VerifyPhoneStatus status;
  final String code;
  final String? errorMessage;
  final Map<String, List<String>> fieldErrors;
  final VerifyPhoneResult? result;

  VerifyPhoneState copyWith({
    VerifyPhoneStatus? status,
    String? code,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
    VerifyPhoneResult? result,
    bool clearResult = false,
  }) {
    return VerifyPhoneState(
      phone: phone,
      status: status ?? this.status,
      code: code ?? this.code,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      result: clearResult ? null : result ?? this.result,
    );
  }

  bool get isFormValid => code.length == 6;

  String? fieldError(String key) {
    final errors = fieldErrors[key];
    if (errors == null || errors.isEmpty) return null;
    return errors.firstWhere(
      (message) => message.trim().isNotEmpty,
      orElse: () => errors.first,
    );
  }

  @override
  List<Object?> get props => [
        phone,
        status,
        code,
        errorMessage,
        fieldErrors,
        result,
      ];
}
