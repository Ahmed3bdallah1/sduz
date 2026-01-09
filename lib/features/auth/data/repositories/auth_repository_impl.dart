import '../../../../core/network/auth_token_provider.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/signup_result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/verify_phone_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_requests.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenProvider,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AuthTokenProvider _tokenProvider;

  @override
  Future<AuthToken> login({
    required String phone,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      LoginRequest(phone: phone, password: password),
    );
    await _tokenProvider.saveAccessToken(response.accessToken);
    return response.toDomain();
  }

  @override
  Future<SignupResult> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? imagePath,
  }) async {
    final dto = await _remoteDataSource.register(
      RegisterRequest(
        name: name,
        phone: phone,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        imagePath: imagePath,
      ),
    );
    return dto.toDomain();
  }

  @override
  Future<VerifyPhoneResult> verifyPhone({
    required String phone,
    required String code,
  }) async {
    final dto = await _remoteDataSource.verifyPhone(
      VerifyPhoneRequest(phone: phone, code: code),
    );
    await _tokenProvider.saveAccessToken(dto.token);
    return dto.toDomain();
  }

  @override
  Future<UserProfile> fetchProfile() async {
    final dto = await _remoteDataSource.fetchProfile();
    return dto.toDomain();
  }

  @override
  Future<UserProfile> editProfile({
    String? name,
    String? phone,
    String? email,
    String? title,
    String? bio,
    String? facebookLink,
    String? siteLink,
    String? whatsappNumber,
    String? imagePath,
  }) async {
    final dto = await _remoteDataSource.editProfile(
      EditProfileRequest(
        name: name,
        phone: phone,
        email: email,
        title: title,
        bio: bio,
        facebookLink: facebookLink,
        siteLink: siteLink,
        whatsappNumber: whatsappNumber,
        imagePath: imagePath,
      ),
    );
    return dto.toDomain();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    return _remoteDataSource.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        password: newPassword,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _tokenProvider.saveAccessToken(null);
  }

  @override
  Future<void> deleteAccount() async {
    await _remoteDataSource.deleteAccount();
    await _tokenProvider.saveAccessToken(null);
  }

  @override
  Future<void> sendResetOtp({required String phone}) {
    return _remoteDataSource.sendResetOtp(
      ResetSendOtpRequest(phone: phone),
    );
  }

  @override
  Future<void> verifyResetOtp({
    required String phone,
    required String code,
  }) {
    return _remoteDataSource.verifyResetOtp(
      ResetVerifyOtpRequest(phone: phone, code: code),
    );
  }

  @override
  Future<void> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) {
    return _remoteDataSource.setNewPassword(
      ResetSetNewPasswordRequest(
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }
}
