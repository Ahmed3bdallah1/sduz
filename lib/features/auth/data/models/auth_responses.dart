import '../../../../core/models/json_types.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/signup_result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_summary.dart';
import '../../domain/entities/verify_phone_result.dart';

class LoginResponseDto {
  LoginResponseDto({
    required this.accessToken,
    required this.raw,
  });

  final String accessToken;
  final JsonMap raw;

  factory LoginResponseDto.fromJson(JsonMap json) {
    final token = _extractToken(json);
    return LoginResponseDto(
      accessToken: token,
      raw: json,
    );
  }

  AuthToken toDomain() => AuthToken(accessToken: accessToken);

  static String _extractToken(JsonMap json) {
    final directToken = json['access_token'] ?? json['token'];
    if (directToken is String && directToken.isNotEmpty) {
      return directToken;
    }

    final data = json['data'];
    if (data is JsonMap) {
      final nestedToken = data['access_token'] ?? data['token'];
      if (nestedToken is String && nestedToken.isNotEmpty) {
        return nestedToken;
      }
    }

    throw const FormatException('Missing access token in login response');
  }
}

class SignupResponseDto {
  SignupResponseDto({
    required this.message,
    required this.user,
    required this.raw,
  });

  final String message;
  final UserSummaryDto user;
  final JsonMap raw;

  factory SignupResponseDto.fromJson(JsonMap json) {
    final message = json['message'] as String? ?? '';
    final data = json['data'];
    if (data is! JsonMap) {
      throw const FormatException('Signup response missing data payload');
    }
    return SignupResponseDto(
      message: message,
      user: UserSummaryDto.fromJson(data),
      raw: json,
    );
  }

  SignupResult toDomain() => SignupResult(
        message: message,
        user: user.toDomain(),
      );
}

class VerifyPhoneResponseDto {
  VerifyPhoneResponseDto({
    required this.message,
    required this.user,
    required this.token,
    required this.raw,
  });

  final String message;
  final UserSummaryDto user;
  final String token;
  final JsonMap raw;

  factory VerifyPhoneResponseDto.fromJson(JsonMap json) {
    final message = json['message'] as String? ?? '';
    final data = json['data'];
    final token = json['token'];

    if (data is! JsonMap) {
      throw const FormatException('Verify phone response missing user data');
    }
    if (token is! String || token.isEmpty) {
      throw const FormatException('Verify phone response missing token');
    }

    return VerifyPhoneResponseDto(
      message: message,
      user: UserSummaryDto.fromJson(data),
      token: token,
      raw: json,
    );
  }

  VerifyPhoneResult toDomain() => VerifyPhoneResult(
        message: message,
        user: user.toDomain(),
        token: token,
      );
}

class UserProfileDto {
  UserProfileDto({
    required this.raw,
    this.id,
    this.name,
    this.phone,
    this.email,
    this.imageUrl,
    this.title,
    this.bio,
    this.facebookLink,
    this.siteLink,
    this.whatsappNumber,
  });

  final JsonMap raw;
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? imageUrl;
  final String? title;
  final String? bio;
  final String? facebookLink;
  final String? siteLink;
  final String? whatsappNumber;

  factory UserProfileDto.fromJson(JsonMap json) {
    return UserProfileDto(
      raw: json,
      id: _parseInt(json['id']),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      imageUrl: json['image'] as String?,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      facebookLink: json['facebook_link'] as String?,
      siteLink: json['site_link'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
    );
  }

  UserProfile toDomain() => UserProfile(
        raw: raw,
        id: id,
        name: name,
        phone: phone,
        email: email,
        imageUrl: imageUrl,
        title: title,
        bio: bio,
        facebookLink: facebookLink,
        siteLink: siteLink,
        whatsappNumber: whatsappNumber,
      );
}

class UserSummaryDto {
  UserSummaryDto({
    required this.raw,
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    this.isVerified,
    this.role,
    this.imageUrl,
  });

  final JsonMap raw;
  final int id;
  final String name;
  final String phone;
  final String email;
  final bool status;
  final bool? isVerified;
  final String? role;
  final String? imageUrl;

  factory UserSummaryDto.fromJson(JsonMap json) {
    final id = _parseInt(json['id']);
    final name = json['name'] as String?;
    final phone = json['phone'] as String?;
    final email = json['email'] as String?;
    final status = json['status'];

    if (id == null || name == null || phone == null || email == null) {
      throw const FormatException('User summary missing required fields');
    }

    return UserSummaryDto(
      raw: json,
      id: id,
      name: name,
      phone: phone,
      email: email,
      status: (status is bool) ? status : status == 1,
      isVerified: _parseBool(json['is_verified']),
      role: json['role'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  UserSummary toDomain() => UserSummary(
        raw: raw,
        id: id,
        name: name,
        phone: phone,
        email: email,
        status: status,
        isVerified: isVerified,
        role: role,
        imageUrl: imageUrl,
      );
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    if (value == '1') return true;
    if (value == '0') return false;
    return value.toLowerCase() == 'true';
  }
  return null;
}
