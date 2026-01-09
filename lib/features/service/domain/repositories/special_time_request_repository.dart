import '../entities/special_time_request.dart';
import '../../data/models/special_time_request_payload.dart';

abstract class SpecialTimeRequestRepository {
  Future<List<SpecialTimeRequest>> fetchRequests();

  Future<SpecialTimeRequest> submitRequest(
    SpecialTimeRequestPayload payload,
  );

  Future<SpecialTimeRequest> cancelRequest(String requestId);
}
