import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sudz/core/consts/tech_endpoints.dart';
import 'package:sudz/core/models/json_types.dart';
import 'package:sudz/core/network/api_request.dart';
import 'package:sudz/core/network/dio_client.dart';

import '../models/tech_job_dto.dart';

class TechJobsRemoteDataSource {
  TechJobsRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<TechJobDto>> fetchJobs({String? filter}) async {
    final apiRequest = ApiRequest<List<TechJobDto>>(
      path: TechEndpoints.technicianJobs,
      method: HttpMethod.get,
      queryParameters: filter != null ? {'filter': filter} : null,
      parseResponse: _parseJobList,
    );
    final response = await _client.send(apiRequest);
    final items = response.data;
    if (items == null) {
      throw const FormatException('Technician jobs response is empty');
    }
    return items;
  }

  Future<TechJobDto> fetchJobDetails(String jobId) async {
    final apiRequest = ApiRequest<TechJobDto>(
      path: TechEndpoints.jobDetails(jobId),
      method: HttpMethod.get,
      parseResponse: _parseJob,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Technician job details response is empty');
    }
    return dto;
  }

  Future<TechJobDto> acceptJob(String jobId) {
    return _postJobAction(jobId, 'accept');
  }

  Future<TechJobDto> rejectJob(String jobId, {String? reason}) {
    return _postJobAction(jobId, 'reject', data: reason != null ? {'reason': reason} : null);
  }

  Future<TechJobDto> arriveJob(String jobId) {
    return _postJobAction(jobId, 'arrive');
  }

  Future<TechJobDto> startJob(String jobId) {
    return _postJobAction(jobId, 'start');
  }

  Future<TechJobDto> completeJob(String jobId) {
    return _postJobAction(jobId, 'complete');
  }

  Future<TechJobDto> uploadEvidence(
    String jobId, {
    required List<File> photos,
    String? category,
  }) async {
    final formData = FormData();
    for (final photo in photos) {
      formData.files.add(
        MapEntry(
          'photos[]',
          await MultipartFile.fromFile(photo.path,
              filename: photo.uri.pathSegments.isNotEmpty
                  ? photo.uri.pathSegments.last
                  : 'evidence.jpg'),
        ),
      );
    }
    if (category != null) {
      formData.fields.add(MapEntry('category', category));
    }

    final apiRequest = ApiRequest<TechJobDto>(
      path: TechEndpoints.jobAction(jobId, 'upload-evidence'),
      method: HttpMethod.post,
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
      parseResponse: _parseJob,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw const FormatException('Upload evidence response is empty');
    }
    return dto;
  }

  Future<TechJobDto> _postJobAction(
    String jobId,
    String action, {
    dynamic data,
  }) async {
    final apiRequest = ApiRequest<TechJobDto>(
      path: TechEndpoints.jobAction(jobId, action),
      method: HttpMethod.post,
      data: data,
      parseResponse: _parseJob,
    );
    final response = await _client.send(apiRequest);
    final dto = response.data;
    if (dto == null) {
      throw FormatException('$action job response is empty');
    }
    return dto;
  }

  TechJobDto _parseJob(dynamic data) {
    if (data is JsonMap) {
      return TechJobDto.fromJson(data);
    }
    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['job'];
      if (nested is JsonMap) {
        return TechJobDto.fromJson(nested);
      }
    }
    throw const FormatException('Unexpected job response shape');
  }

  List<TechJobDto> _parseJobList(dynamic data) {
    final rawList = _extractList(data);
    if (rawList == null) {
      throw const FormatException('Unexpected jobs list response');
    }
    return rawList
        .whereType<JsonMap>()
        .map(TechJobDto.fromJson)
        .toList(growable: false);
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['data'],
        data['jobs'],
        data['items'],
        data['results'],
      ];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return null;
  }
}
