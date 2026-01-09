import 'package:equatable/equatable.dart';

import 'package:sudz/features/auth/domain/entities/signup_result.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final bool isPasswordVisible;
  final String? errorMessage;
  final Map<String, List<String>> fieldErrors;
  final SignupResult? result;

  const SignupState({
    this.status = SignupStatus.initial,
    this.name = '',
    this.phoneNumber = '',
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.errorMessage,
    this.fieldErrors = const <String, List<String>>{},
    this.result,
  });

  SignupState copyWith({
    SignupStatus? status,
    String? name,
    String? phoneNumber,
    String? email,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
    SignupResult? result,
    bool clearResult = false,
  }) {
    return SignupState(
      status: status ?? this.status,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      result: clearResult ? null : result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    phoneNumber,
    email,
    password,
    isPasswordVisible,
    errorMessage,
    fieldErrors,
    result,
  ];
}

extension SignupStateX on SignupState {
  bool get isFormValid =>
      name.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      email.isNotEmpty &&
      password.length >= 6;

  String? fieldError(String key) {
    final errors = fieldErrors[key];
    if (errors == null || errors.isEmpty) {
      return null;
    }
    return errors.firstWhere(
      (element) => element.trim().isNotEmpty,
      orElse: () => errors.first,
    );
  }
}
