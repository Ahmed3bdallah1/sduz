import '../../domain/entities/app_content_page.dart';
import '../../domain/repositories/app_content_repository.dart';
import '../datasources/app_content_remote_data_source.dart';

class AppContentRepositoryImpl implements AppContentRepository {
  AppContentRepositoryImpl(this._remoteDataSource);

  final AppContentRemoteDataSource _remoteDataSource;

  @override
  Future<AppContentPage> fetchTerms() {
    return _remoteDataSource.fetchTerms();
  }

  @override
  Future<AppContentPage> fetchPrivacy() {
    return _remoteDataSource.fetchPrivacy();
  }

  @override
  Future<AppContentPage> fetchAbout() {
    return _remoteDataSource.fetchAbout();
  }

  @override
  Future<AppContentPage> fetchFaq() {
    return _remoteDataSource.fetchFaq();
  }

  @override
  Future<AppContentPage> fetchContact() {
    return _remoteDataSource.fetchContact();
  }
}
