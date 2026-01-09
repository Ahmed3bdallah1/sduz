import '../../domain/entities/package.dart';
import '../../domain/entities/user_package.dart';
import '../../domain/repositories/packages_repository.dart';
import '../datasources/packages_remote_data_source.dart';
import '../models/purchase_package_payload.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  PackagesRepositoryImpl(this._remoteDataSource);

  final PackagesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Package>> fetchPackages() async {
    final dtos = await _remoteDataSource.fetchPackages();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Package> fetchPackageDetails(String packageId) async {
    final dto = await _remoteDataSource.fetchPackageDetails(packageId);
    return dto.toEntity();
  }

  @override
  Future<UserPackage> purchasePackage({
    required String packageId,
    required String paymentMethod,
  }) async {
    final payload = PurchasePackagePayload(paymentMethod: paymentMethod);
    final dto = await _remoteDataSource.purchasePackage(
      packageId: packageId,
      payload: payload,
    );
    return dto.toEntity();
  }

  @override
  Future<List<UserPackage>> fetchMyActivePackages() async {
    final dtos = await _remoteDataSource.fetchMyActivePackages();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

