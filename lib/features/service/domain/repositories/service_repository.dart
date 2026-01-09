import '../entities/service.dart';
import '../entities/service_category.dart';

abstract class ServiceRepository {
  /// Fetch all service categories
  Future<List<ServiceCategory>> fetchServiceCategories();

  /// Fetch all services, optionally filtered by category
  Future<List<Service>> fetchServices({String? categoryId});

  /// Fetch details of a specific service
  Future<Service> fetchServiceDetails(String serviceId);
}

