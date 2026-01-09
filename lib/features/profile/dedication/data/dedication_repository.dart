import 'package:sudz/features/profile/shared/data/profile_mock_data.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

class DedicationRepository {
  const DedicationRepository();

  Future<List<ProfileDedicationType>> fetchDedicationTypes() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return kProfileDedicationTypes;
  }

  Future<void> submitDedication({
    required String phoneNumber,
    required ProfileDedicationType type,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }
}
