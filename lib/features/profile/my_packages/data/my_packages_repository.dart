import 'package:sudz/features/packages/domain/repositories/packages_repository.dart';
import 'package:sudz/features/profile/shared/models/models.dart';

class MyPackagesRepository {
  const MyPackagesRepository(this._packagesRepository);

  final PackagesRepository _packagesRepository;

  Future<List<ProfilePackage>> fetchPackages() async {
    final userPackages = await _packagesRepository.fetchMyActivePackages();
    return userPackages
        .map((userPackage) => ProfilePackage.fromUserPackage(userPackage))
        .toList();
  }
}
