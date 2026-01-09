import 'package:sudz/features/profile/shared/data/profile_mock_data.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

class ProfileHomeRepository {
  const ProfileHomeRepository();

  String fetchUserName() => kProfileUserName;

  List<ProfileQuickLink> fetchQuickLinks() => kProfileQuickLinks;

  List<ProfilePolicyItem> fetchPolicyItems() => kProfilePolicyItems;

  List<ProfileLanguageOption> fetchLanguageOptions() => kProfileLanguages;
}
