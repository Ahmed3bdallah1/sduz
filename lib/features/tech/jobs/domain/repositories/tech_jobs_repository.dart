import '../../models/tech_job.dart';

abstract class TechJobsRepository {
  Future<List<TechJob>> fetchJobs({String? filter});

  Future<TechJob> fetchJobDetails(String jobId);

  Future<TechJob> acceptJob(String jobId);

  Future<TechJob> rejectJob(String jobId, {String? reason});

  Future<TechJob> arriveJob(String jobId);

  Future<TechJob> startJob(String jobId);

  Future<TechJob> completeJob(String jobId);
}
