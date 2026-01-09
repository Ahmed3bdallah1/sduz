import 'package:equatable/equatable.dart';
import 'package:sudz/features/packages/data/models/models.dart';

abstract class PackageCheckoutEvent extends Equatable {
  const PackageCheckoutEvent();

  @override
  List<Object?> get props => [];
}

class PackageCheckoutStarted extends PackageCheckoutEvent {
  final Package package;

  const PackageCheckoutStarted(this.package);

  @override
  List<Object?> get props => [package];
}

class PackageCheckoutPaymentSelected extends PackageCheckoutEvent {
  final String methodId;

  const PackageCheckoutPaymentSelected(this.methodId);

  @override
  List<Object?> get props => [methodId];
}

class PackageCheckoutSubmitted extends PackageCheckoutEvent {
  const PackageCheckoutSubmitted();
}
