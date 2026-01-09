import '../entities/package.dart';
import '../entities/user_package.dart';

abstract class PackagesRepository {
  /// Fetch all available packages
  Future<List<Package>> fetchPackages();

  /// Fetch details of a specific package
  Future<Package> fetchPackageDetails(String packageId);

  /// Purchase a package
  Future<UserPackage> purchasePackage({
    required String packageId,
    required String paymentMethod,
  });

  /// Fetch user's active packages
  Future<List<UserPackage>> fetchMyActivePackages();
}

