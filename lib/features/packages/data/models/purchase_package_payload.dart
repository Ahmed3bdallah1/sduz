import '../../../../core/models/json_types.dart';

class PurchasePackagePayload {
  const PurchasePackagePayload({
    required this.paymentMethod,
  });

  final String paymentMethod;

  JsonMap toJson() {
    return <String, dynamic>{
      'payment_method': paymentMethod,
    };
  }
}

