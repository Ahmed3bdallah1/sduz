import '../entities/app_content_page.dart';

abstract class AppContentRepository {
  Future<AppContentPage> fetchTerms();
  Future<AppContentPage> fetchPrivacy();
  Future<AppContentPage> fetchAbout();
  Future<AppContentPage> fetchFaq();
  Future<AppContentPage> fetchContact();
}
