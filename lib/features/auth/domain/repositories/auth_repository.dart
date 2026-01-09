import '../entities/auth_token.dart';
import '../entities/signup_result.dart';
import '../entities/user_profile.dart';
import '../entities/verify_phone_result.dart';

abstract class AuthRepository {
  Future<AuthToken> login({
    required String phone,
    required String password,
  });

  Future<SignupResult> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? imagePath,
  });

  Future<VerifyPhoneResult> verifyPhone({
    required String phone,
    required String code,
  });

  Future<UserProfile> fetchProfile();

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
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });

  Future<void> logout();

  Future<void> deleteAccount();

  Future<void> sendResetOtp({required String phone});

  Future<void> verifyResetOtp({
    required String phone,
    required String code,
  });

  Future<void> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}
