import '../../domain/entities/service.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_data_source.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  ServiceRepositoryImpl(this._remoteDataSource);

  final ServiceRemoteDataSource _remoteDataSource;

  @override
  Future<List<ServiceCategory>> fetchServiceCategories() async {
    final dtos = await _remoteDataSource.fetchServiceCategories();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Service>> fetchServices({String? categoryId}) async {
    final dtos = await _remoteDataSource.fetchServices(categoryId: categoryId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Service> fetchServiceDetails(String serviceId) async {
    final dto = await _remoteDataSource.fetchServiceDetails(serviceId);
    return dto.toEntity();
  }
}

