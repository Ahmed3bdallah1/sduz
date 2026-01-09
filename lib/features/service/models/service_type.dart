import 'package:equatable/equatable.dart';
import '../domain/entities/service.dart';

/// Represents a service option that can be selected for the order.
class ServiceType extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final int price;
  final String currency;
  final List<ServiceStep> steps;

  const ServiceType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    this.currency = 'ريال',
    this.steps = const [],
  });

  /// Factory to convert domain Service entity to ServiceType
  factory ServiceType.fromService(Service service) {
    final steps = service.features
            ?.map((feature) => ServiceStep(
                  name: feature,
                  description: feature,
                ))
            .toList() ??
        [];

    return ServiceType(
      id: service.id,
      title: service.title,
      subtitle: service.description,
      price: service.price.toInt(),
      currency: 'ريال',
      steps: steps,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, price, currency, steps];
}

/// List entry describing a stage within the service flow.
class ServiceStep extends Equatable {
  final String name;
  final String description;

  const ServiceStep({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}
