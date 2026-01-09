import '../../../../core/consts/app_endpoints.dart';
import '../../../../core/models/json_types.dart';
import '../../../../core/network/api_request.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/app_content_page.dart';

class AppContentRemoteDataSource {
  AppContentRemoteDataSource(this._client);

  final DioClient _client;

  Future<AppContentPage> fetchTerms() {
    return _fetchContent(
      slug: 'terms',
      path: AppEndpoints.customer10AppContentTermsConditions.path,
    );
  }

  Future<AppContentPage> fetchPrivacy() {
    return _fetchContent(
      slug: 'privacy',
      path: AppEndpoints.customer10AppContentPrivacyPolicy.path,
    );
  }

  Future<AppContentPage> fetchAbout() {
    return _fetchContent(
      slug: 'about',
      path: AppEndpoints.customer10AppContentAboutUs.path,
    );
  }

  Future<AppContentPage> fetchFaq() {
    return _fetchContent(
      slug: 'faq',
      path: AppEndpoints.customer10AppContentFaq.path,
    );
  }

  Future<AppContentPage> fetchContact() {
    return _fetchContent(
      slug: 'contact',
      path: AppEndpoints.customer10AppContentContactInfo.path,
    );
  }

  Future<AppContentPage> _fetchContent({
    required String slug,
    required String path,
  }) async {
    final apiRequest = ApiRequest<AppContentPage>(
      path: path,
      method: HttpMethod.get,
      requiresAuth: false,
      parseResponse: (data) => _parseContent(slug: slug, data: data),
    );
    final response = await _client.send(apiRequest);
    final page = response.data;
    if (page == null) {
      throw FormatException('Content "$slug" response is empty');
    }
    return page;
  }

  AppContentPage _parseContent({
    required String slug,
    required dynamic data,
  }) {
    if (data is String && data.trim().isNotEmpty) {
      return AppContentPage(slug: slug, content: data.trim());
    }

    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is JsonMap) {
        final content = _stringify(
              first['content'] ?? first['body'] ?? first['html'],
            ) ??
            first.values.firstWhere(
              (value) => value is String && value.trim().isNotEmpty,
              orElse: () => '',
            ).toString();
        return AppContentPage(slug: slug, content: content);
      }
    }

    if (data is JsonMap) {
      final content = _stringify(
        data['content'] ?? data['body'] ?? data['html'] ?? data['data'],
      );
      if (content != null && content.isNotEmpty) {
        return AppContentPage(slug: slug, content: content);
      }
      if (data.values.any((value) => value is String)) {
        final firstString = data.values
            .firstWhere((value) => value is String) as String;
        return AppContentPage(slug: slug, content: firstString);
      }
    }

    throw const FormatException('Unexpected app content response shape');
  }

  String? _stringify(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.trim();
    }
    return value.toString();
  }
}
