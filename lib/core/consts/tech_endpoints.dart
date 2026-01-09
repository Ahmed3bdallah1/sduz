class TechEndpoints {
  const TechEndpoints._();

  static const String login = '/auth/login';
  static const String profile = '/auth/profile';
  static const String logout = '/auth/logout';

  static const String technicianProfile = '/technician/profile';
  static const String technicianProfileUpdate = '/technician/profile/update';
  static const String technicianPerformance = '/technician/performance';
  static const String technicianBadges = '/technician/badges';
  static const String technicianAvailability = '/technician/availability';

  static const String technicianJobs = '/technician/jobs';
  static String jobDetails(String id) => '/technician/jobs/$id';
  static String jobAction(String id, String action) =>
      '/technician/jobs/$id/$action';

  static const String technicianEarnings = '/technician/earnings';
  static String technicianEarningDetails(String id) =>
      '/technician/earnings/$id';
  static const String technicianTips = '/technician/earnings/tips/received';

  static const String technicianSync = '/technician/sync';
}
