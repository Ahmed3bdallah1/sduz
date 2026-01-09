import '../../models/tech_job.dart';
import '../../domain/repositories/tech_jobs_repository.dart';
import '../datasources/tech_jobs_remote_data_source.dart';

class TechJobsRepositoryImpl implements TechJobsRepository {
  TechJobsRepositoryImpl(this._remoteDataSource);

  final TechJobsRemoteDataSource _remoteDataSource;

  @override
  Future<List<TechJob>> fetchJobs({String? filter}) async {
    final dtos = await _remoteDataSource.fetchJobs(filter: filter);
    return dtos.map((dto) => dto.toEntity()).toList(growable: false);
  }

  @override
  Future<TechJob> fetchJobDetails(String jobId) async {
    final dto = await _remoteDataSource.fetchJobDetails(jobId);
    return dto.toEntity();
  }

  @override
  Future<TechJob> acceptJob(String jobId) async {
    final dto = await _remoteDataSource.acceptJob(jobId);
    return dto.toEntity();
  }

  @override
  Future<TechJob> rejectJob(String jobId, {String? reason}) async {
    final dto = await _remoteDataSource.rejectJob(jobId, reason: reason);
    return dto.toEntity();
  }

  @override
  Future<TechJob> arriveJob(String jobId) async {
    final dto = await _remoteDataSource.arriveJob(jobId);
    return dto.toEntity();
  }

  @override
  Future<TechJob> startJob(String jobId) async {
    final dto = await _remoteDataSource.startJob(jobId);
    return dto.toEntity();
  }

  @override
  Future<TechJob> completeJob(String jobId) async {
    final dto = await _remoteDataSource.completeJob(jobId);
    return dto.toEntity();
  }
}
