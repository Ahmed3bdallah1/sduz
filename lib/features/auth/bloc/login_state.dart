import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

/// Extension methods for LoginStatus enum
extension LoginStatusX on LoginStatus {
  bool get isInitial => this == LoginStatus.initial;
  bool get isLoading => this == LoginStatus.loading;
  bool get isSuccess => this == LoginStatus.success;
  bool get isFailure => this == LoginStatus.failure;
}

/// Single state class for Login feature
class LoginState extends Equatable {
  final LoginStatus status;
  final String emailOrPhone;
  final String password;
  final bool isPasswordVisible;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.emailOrPhone = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  /// CopyWith method for immutable state updates
  LoginState copyWith({
    LoginStatus? status,
    String? emailOrPhone,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    emailOrPhone,
    password,
    isPasswordVisible,
    errorMessage,
  ];
}

/// Extension methods for LoginState
extension LoginStateX on LoginState {
  /// Check if the form is valid
  bool get isFormValid =>
      emailOrPhone.isNotEmpty && password.isNotEmpty && password.length >= 6;

  /// Check if the state is in a loading state
  bool get isLoading => status.isLoading;

  /// Check if the state has an error
  bool get hasError => status.isFailure && errorMessage != null;

  /// Get a loading state with current form data
  LoginState toLoading() =>
      copyWith(status: LoginStatus.loading, errorMessage: null);

  /// Get a success state
  LoginState toSuccess() =>
      copyWith(status: LoginStatus.success, errorMessage: null);

  /// Get a failure state with an error message
  LoginState toFailure(String message) =>
      copyWith(status: LoginStatus.failure, errorMessage: message);

  /// Get an initial state (clear form)
  LoginState toInitial() => const LoginState();

  /// Update email or phone
  LoginState updateEmailOrPhone(String value) =>
      copyWith(emailOrPhone: value, errorMessage: null);

  /// Update password
  LoginState updatePassword(String value) =>
      copyWith(password: value, errorMessage: null);

  /// Toggle password visibility
  LoginState togglePasswordVisibility() =>
      copyWith(isPasswordVisible: !isPasswordVisible);
}
