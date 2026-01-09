import 'package:dio/dio.dart';

import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_requests.dart';
import '../models/auth_responses.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final DioClient _client;

  Future<LoginResponseDto> login(LoginRequest request) async {
    final apiRequest = ApiRequest<LoginResponseDto>(
      path: AppEndpoints.customer1AuthenticationLogin.path,
      method: HttpMethod.post,
      data: request.toJson(),
      requiresAuth: false,
      parseResponse: _parseLoginResponse,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Login response is empty');
    }
    return dto;
  }

  Future<SignupResponseDto> register(RegisterRequest request) async {
    final formData = await request.toFormData();
    final apiRequest = ApiRequest<SignupResponseDto>(
      path: AppEndpoints.customer1AuthenticationRegister.path,
      method: HttpMethod.post,
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
      requiresAuth: false,
      parseResponse: _parseSignupResponse,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Signup response is empty');
    }
    return dto;
  }

  Future<VerifyPhoneResponseDto> verifyPhone(VerifyPhoneRequest request) async {
    final apiRequest = ApiRequest<VerifyPhoneResponseDto>(
      path: AppEndpoints.customer1AuthenticationVerifyPhone.path,
      method: HttpMethod.post,
      data: request.toJson(),
      requiresAuth: false,
      parseResponse: _parseVerifyPhoneResponse,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Verify phone response is empty');
    }
    return dto;
  }

  Future<UserProfileDto> fetchProfile() async {
    final apiRequest = ApiRequest<UserProfileDto>(
      path: AppEndpoints.customer1AuthenticationGetProfile.path,
      method: HttpMethod.get,
      parseResponse: _parseProfileResponse,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Profile response is empty');
    }
    return dto;
  }

  Future<UserProfileDto> editProfile(EditProfileRequest request) async {
    final formData = await request.toFormData();
    final apiRequest = ApiRequest<UserProfileDto>(
      path: AppEndpoints.customer1AuthenticationEditProfile.path,
      method: HttpMethod.post,
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
      parseResponse: _parseProfileResponse,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Profile response is empty');
    }
    return dto;
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    final apiRequest = ApiRequest<dynamic>(
      path: AppEndpoints.customer1AuthenticationChangePassword.path,
      method: HttpMethod.post,
      data: request.toJson(),
    );
    await _client.send(apiRequest);
  }

  Future<void> logout() async {
    final apiRequest = ApiRequest<dynamic>(
      path: AppEndpoints.customer1AuthenticationLogout.path,
      method: HttpMethod.post,
    );
    await _client.send(apiRequest);
  }

  Future<void> deleteAccount() async {
    final apiRequest = ApiRequest<dynamic>(
      path: AppEndpoints.sudzcustomextensions1AuthenticationDeleteAccount.path,
      method: HttpMethod.delete,
    );
    await _client.send(apiRequest);
  }

  Future<void> sendResetOtp(ResetSendOtpRequest request) async {
    final apiRequest = ApiRequest<dynamic>(
      path: AppEndpoints
          .sudzcustomextensions1AuthenticationResetPasswordSendOtp
          .path,
      method: HttpMethod.post,
      data: request.toJson(),
      requiresAuth: false,
    );
    await _client.send(apiRequest);
  }

  Future<void> verifyResetOtp(ResetVerifyOtpRequest request) async {
    final apiRequest = ApiRequest<dynamic>(
      path: AppEndpoints
          .sudzcustomextensions1AuthenticationResetPasswordVerifyOtp
          .path,
      method: HttpMethod.post,
      data: request.toJson(),
      requiresAuth: false,
    );
    await _client.send(apiRequest);
  }

  Future<void> setNewPassword(ResetSetNewPasswordRequest request) async {
    final apiRequest = ApiRequest<dynamic>(
      path: AppEndpoints
          .sudzcustomextensions1AuthenticationResetPasswordSetNewPassword
          .path,
      method: HttpMethod.post,
      data: request.toJson(),
      requiresAuth: false,
    );
    await _client.send(apiRequest);
  }

  LoginResponseDto _parseLoginResponse(dynamic data) {
    if (data is! JsonMap) {
      throw const FormatException('Unexpected login response shape');
    }
    return LoginResponseDto.fromJson(data);
  }

  SignupResponseDto _parseSignupResponse(dynamic data) {
    if (data is! JsonMap) {
      throw const FormatException('Unexpected signup response shape');
    }
    return SignupResponseDto.fromJson(data);
  }

  VerifyPhoneResponseDto _parseVerifyPhoneResponse(dynamic data) {
    if (data is! JsonMap) {
      throw const FormatException('Unexpected verify phone response shape');
    }
    return VerifyPhoneResponseDto.fromJson(data);
  }

  UserProfileDto _parseProfileResponse(dynamic data) {
    if (data is JsonMap) {
      return UserProfileDto.fromJson(data);
    }
    if (data is List && data.isNotEmpty && data.first is JsonMap) {
      return UserProfileDto.fromJson(data.first as JsonMap);
    }
    throw const FormatException('Unexpected profile response shape');
  }
}
