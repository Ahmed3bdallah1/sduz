import 'package:equatable/equatable.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

enum ProfileHomeStatus { initial, loading, success, failure }

extension ProfileHomeStatusX on ProfileHomeStatus {
  bool get isInitial => this == ProfileHomeStatus.initial;
  bool get isLoading => this == ProfileHomeStatus.loading;
  bool get isSuccess => this == ProfileHomeStatus.success;
  bool get isFailure => this == ProfileHomeStatus.failure;
}

class ProfileHomeState extends Equatable {
  final ProfileHomeStatus status;
  final String userName;
  final List<ProfileQuickLink> quickLinks;
  final List<ProfilePolicyItem> policies;
  final List<ProfileLanguageOption> languages;
  final String selectedLanguageCode;
  final String? errorMessage;

  const ProfileHomeState({
    this.status = ProfileHomeStatus.initial,
    this.userName = '',
    this.quickLinks = const [],
    this.policies = const [],
    this.languages = const [],
    this.selectedLanguageCode = 'ar',
    this.errorMessage,
  });

  ProfileHomeState copyWith({
    ProfileHomeStatus? status,
    String? userName,
    List<ProfileQuickLink>? quickLinks,
    List<ProfilePolicyItem>? policies,
    List<ProfileLanguageOption>? languages,
    String? selectedLanguageCode,
    String? errorMessage,
  }) {
    return ProfileHomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      quickLinks: quickLinks ?? this.quickLinks,
      policies: policies ?? this.policies,
      languages: languages ?? this.languages,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userName,
    quickLinks,
    policies,
    languages,
    selectedLanguageCode,
    errorMessage,
  ];
}
