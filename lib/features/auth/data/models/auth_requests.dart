import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/models/json_types.dart';

class LoginRequest {
  LoginRequest({
    required this.phone,
    required this.password,
  });

  final String phone;
  final String password;

  JsonMap toJson() => {
        'phone': phone,
        'password': password,
      };
}

class RegisterRequest {
  RegisterRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.imagePath,
  });

  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? imagePath;

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    if (imagePath != null && imagePath!.isNotEmpty) {
      final file = File(imagePath!);
      if (await file.exists()) {
        map['image'] = await MultipartFile.fromFile(imagePath!);
      }
    }

    return FormData.fromMap(map);
  }
}

class EditProfileRequest {
  EditProfileRequest({
    this.name,
    this.phone,
    this.email,
    this.title,
    this.bio,
    this.facebookLink,
    this.siteLink,
    this.whatsappNumber,
    this.imagePath,
  });

  final String? name;
  final String? phone;
  final String? email;
  final String? title;
  final String? bio;
  final String? facebookLink;
  final String? siteLink;
  final String? whatsappNumber;
  final String? imagePath;

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    void addIfNotNull(String key, String? value) {
      if (value != null) map[key] = value;
    }

    addIfNotNull('name', name);
    addIfNotNull('phone', phone);
    addIfNotNull('email', email);
    addIfNotNull('title', title);
    addIfNotNull('bio', bio);
    addIfNotNull('facebook_link', facebookLink);
    addIfNotNull('site_link', siteLink);
    addIfNotNull('whatsapp_number', whatsappNumber);

    if (imagePath != null && imagePath!.isNotEmpty) {
      final file = File(imagePath!);
      if (await file.exists()) {
        map['image'] = await MultipartFile.fromFile(imagePath!);
      }
    }

    return FormData.fromMap(map);
  }
}

class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  JsonMap toJson() => {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}

class ResetSendOtpRequest {
  ResetSendOtpRequest({required this.phone});

  final String phone;

  JsonMap toJson() => {'phone': phone};
}

class ResetVerifyOtpRequest {
  ResetVerifyOtpRequest({
    required this.phone,
    required this.code,
  });

  final String phone;
  final String code;

  JsonMap toJson() => {
        'phone': phone,
        'code': code,
      };
}

class ResetSetNewPasswordRequest {
  ResetSetNewPasswordRequest({
    required this.resetToken,
    required this.password,
    required this.passwordConfirmation,
  });

  final String resetToken;
  final String password;
  final String passwordConfirmation;

  JsonMap toJson() => {
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
}

class VerifyPhoneRequest {
  VerifyPhoneRequest({
    required this.phone,
    required this.code,
  });

  final String phone;
  final String code;

  JsonMap toJson() => {
        'phone': phone,
        'code': code,
      };
}
