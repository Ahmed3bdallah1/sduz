import '../../domain/entities/special_time_request.dart';
import '../../domain/repositories/special_time_request_repository.dart';
import '../datasources/special_time_request_remote_data_source.dart';
import '../models/special_time_request_payload.dart';

class SpecialTimeRequestRepositoryImpl implements SpecialTimeRequestRepository {
  SpecialTimeRequestRepositoryImpl(this._remoteDataSource);

  final SpecialTimeRequestRemoteDataSource _remoteDataSource;

  @override
  Future<List<SpecialTimeRequest>> fetchRequests() async {
    final dtos = await _remoteDataSource.fetchRequests();
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<SpecialTimeRequest> submitRequest(
    SpecialTimeRequestPayload payload,
  ) async {
    final dto = await _remoteDataSource.submitRequest(payload);
    return dto.toEntity();
  }

  @override
  Future<SpecialTimeRequest> cancelRequest(String requestId) async {
    final dto = await _remoteDataSource.cancelRequest(requestId);
    return dto.toEntity();
  }
}
