// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated via tool/generate_endpoints.dart

class AppEndpoint {
  final String id;
  final String name;
  final String method;
  final String path;
  final String collection;
  final List<String> groupPath;

  const AppEndpoint({
    required this.id,
    required this.name,
    required this.method,
    required this.path,
    required this.collection,
    required this.groupPath,
  });
}

class AppEndpoints {
  const AppEndpoints._();

  /// GET /api/app-content/about · Sudz - Customer API · 10. App Content
  static const AppEndpoint customer10AppContentAboutUs = AppEndpoint(
    id: 'customer10AppContentAboutUs',
    name: 'About Us',
    method: 'GET',
    path: '/api/app-content/about',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '10. App Content',
    ],
  );

  /// GET /api/app-content/contact · Sudz - Customer API · 10. App Content
  static const AppEndpoint customer10AppContentContactInfo = AppEndpoint(
    id: 'customer10AppContentContactInfo',
    name: 'Contact Info',
    method: 'GET',
    path: '/api/app-content/contact',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '10. App Content',
    ],
  );

  /// GET /api/app-content/faq · Sudz - Customer API · 10. App Content
  static const AppEndpoint customer10AppContentFaq = AppEndpoint(
    id: 'customer10AppContentFaq',
    name: 'FAQ',
    method: 'GET',
    path: '/api/app-content/faq',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '10. App Content',
    ],
  );

  /// GET /api/app-content/privacy · Sudz - Customer API · 10. App Content
  static const AppEndpoint customer10AppContentPrivacyPolicy = AppEndpoint(
    id: 'customer10AppContentPrivacyPolicy',
    name: 'Privacy Policy',
    method: 'GET',
    path: '/api/app-content/privacy',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '10. App Content',
    ],
  );

  /// GET /api/app-content/terms · Sudz - Customer API · 10. App Content
  static const AppEndpoint customer10AppContentTermsConditions = AppEndpoint(
    id: 'customer10AppContentTermsConditions',
    name: 'Terms & Conditions',
    method: 'GET',
    path: '/api/app-content/terms',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '10. App Content',
    ],
  );

  /// POST /api/auth/change-password · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationChangePassword = AppEndpoint(
    id: 'customer1AuthenticationChangePassword',
    name: 'Change Password',
    method: 'POST',
    path: '/api/auth/change-password',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/edit-profile · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationEditProfile = AppEndpoint(
    id: 'customer1AuthenticationEditProfile',
    name: 'Edit Profile',
    method: 'POST',
    path: '/api/auth/edit-profile',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// GET /api/auth/profile · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationGetProfile = AppEndpoint(
    id: 'customer1AuthenticationGetProfile',
    name: 'Get Profile',
    method: 'GET',
    path: '/api/auth/profile',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/login · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationLogin = AppEndpoint(
    id: 'customer1AuthenticationLogin',
    name: 'Login',
    method: 'POST',
    path: '/api/auth/login',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/logout · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationLogout = AppEndpoint(
    id: 'customer1AuthenticationLogout',
    name: 'Logout',
    method: 'POST',
    path: '/api/auth/logout',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/register · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationRegister = AppEndpoint(
    id: 'customer1AuthenticationRegister',
    name: 'Register',
    method: 'POST',
    path: '/api/auth/register',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/verify-phone · Sudz - Customer API · 1. Authentication
  static const AppEndpoint customer1AuthenticationVerifyPhone = AppEndpoint(
    id: 'customer1AuthenticationVerifyPhone',
    name: 'Verify Phone',
    method: 'POST',
    path: '/api/auth/verify-phone',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/addresses · Sudz - Customer API · 2. Addresses
  static const AppEndpoint customer2AddressesCreateAddress = AppEndpoint(
    id: 'customer2AddressesCreateAddress',
    name: 'Create Address',
    method: 'POST',
    path: '/api/addresses',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '2. Addresses',
    ],
  );

  /// DELETE /api/addresses/1 · Sudz - Customer API · 2. Addresses
  static const AppEndpoint customer2AddressesDeleteAddress = AppEndpoint(
    id: 'customer2AddressesDeleteAddress',
    name: 'Delete Address',
    method: 'DELETE',
    path: '/api/addresses/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '2. Addresses',
    ],
  );

  /// GET /api/addresses · Sudz - Customer API · 2. Addresses
  static const AppEndpoint customer2AddressesListAddresses = AppEndpoint(
    id: 'customer2AddressesListAddresses',
    name: 'List Addresses',
    method: 'GET',
    path: '/api/addresses',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '2. Addresses',
    ],
  );

  /// POST /api/addresses/1/set-default · Sudz - Customer API · 2. Addresses
  static const AppEndpoint customer2AddressesSetDefaultAddress = AppEndpoint(
    id: 'customer2AddressesSetDefaultAddress',
    name: 'Set Default Address',
    method: 'POST',
    path: '/api/addresses/1/set-default',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '2. Addresses',
    ],
  );

  /// PUT /api/addresses/1 · Sudz - Customer API · 2. Addresses
  static const AppEndpoint customer2AddressesUpdateAddress = AppEndpoint(
    id: 'customer2AddressesUpdateAddress',
    name: 'Update Address',
    method: 'PUT',
    path: '/api/addresses/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '2. Addresses',
    ],
  );

  /// POST /api/cars · Sudz - Customer API · 3. Cars
  static const AppEndpoint customer3CarsAddCar = AppEndpoint(
    id: 'customer3CarsAddCar',
    name: 'Add Car',
    method: 'POST',
    path: '/api/cars',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '3. Cars',
    ],
  );

  /// DELETE /api/cars/1 · Sudz - Customer API · 3. Cars
  static const AppEndpoint customer3CarsDeleteCar = AppEndpoint(
    id: 'customer3CarsDeleteCar',
    name: 'Delete Car',
    method: 'DELETE',
    path: '/api/cars/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '3. Cars',
    ],
  );

  /// GET /api/car-sizes · Sudz - Customer API · 3. Cars
  static const AppEndpoint customer3CarsGetCarSizes = AppEndpoint(
    id: 'customer3CarsGetCarSizes',
    name: 'Get Car Sizes',
    method: 'GET',
    path: '/api/car-sizes',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '3. Cars',
    ],
  );

  /// GET /api/cars · Sudz - Customer API · 3. Cars
  static const AppEndpoint customer3CarsListCars = AppEndpoint(
    id: 'customer3CarsListCars',
    name: 'List Cars',
    method: 'GET',
    path: '/api/cars',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '3. Cars',
    ],
  );

  /// POST /api/cars/1/set-primary · Sudz - Customer API · 3. Cars
  static const AppEndpoint customer3CarsSetPrimaryCar = AppEndpoint(
    id: 'customer3CarsSetPrimaryCar',
    name: 'Set Primary Car',
    method: 'POST',
    path: '/api/cars/1/set-primary',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '3. Cars',
    ],
  );

  /// PUT /api/cars/1 · Sudz - Customer API · 3. Cars
  static const AppEndpoint customer3CarsUpdateCar = AppEndpoint(
    id: 'customer3CarsUpdateCar',
    name: 'Update Car',
    method: 'PUT',
    path: '/api/cars/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '3. Cars',
    ],
  );

  /// GET /api/services · Sudz - Customer API · 4. Services
  static const AppEndpoint customer4ServicesBrowseServices = AppEndpoint(
    id: 'customer4ServicesBrowseServices',
    name: 'Browse Services',
    method: 'GET',
    path: '/api/services',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '4. Services',
    ],
  );

  /// GET /api/service-categories · Sudz - Customer API · 4. Services
  static const AppEndpoint customer4ServicesListServiceCategories = AppEndpoint(
    id: 'customer4ServicesListServiceCategories',
    name: 'List Service Categories',
    method: 'GET',
    path: '/api/service-categories',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '4. Services',
    ],
  );

  /// GET /api/services/1 · Sudz - Customer API · 4. Services
  static const AppEndpoint customer4ServicesServiceDetails = AppEndpoint(
    id: 'customer4ServicesServiceDetails',
    name: 'Service Details',
    method: 'GET',
    path: '/api/services/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '4. Services',
    ],
  );

  /// GET /api/packages · Sudz - Customer API · 5. Packages
  static const AppEndpoint customer5PackagesListPackages = AppEndpoint(
    id: 'customer5PackagesListPackages',
    name: 'List Packages',
    method: 'GET',
    path: '/api/packages',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '5. Packages',
    ],
  );

  /// GET /api/packages/my-packages · Sudz - Customer API · 5. Packages
  static const AppEndpoint customer5PackagesMyActivePackages = AppEndpoint(
    id: 'customer5PackagesMyActivePackages',
    name: 'My Active Packages',
    method: 'GET',
    path: '/api/packages/my-packages',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '5. Packages',
    ],
  );

  /// GET /api/packages/1 · Sudz - Customer API · 5. Packages
  static const AppEndpoint customer5PackagesPackageDetails = AppEndpoint(
    id: 'customer5PackagesPackageDetails',
    name: 'Package Details',
    method: 'GET',
    path: '/api/packages/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '5. Packages',
    ],
  );

  /// POST /api/packages/1/purchase · Sudz - Customer API · 5. Packages
  static const AppEndpoint customer5PackagesPurchasePackage = AppEndpoint(
    id: 'customer5PackagesPurchasePackage',
    name: 'Purchase Package',
    method: 'POST',
    path: '/api/packages/1/purchase',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '5. Packages',
    ],
  );

  /// GET /api/bookings/1 · Sudz - Customer API · 6. Bookings
  static const AppEndpoint customer6BookingsBookingDetails = AppEndpoint(
    id: 'customer6BookingsBookingDetails',
    name: 'Booking Details',
    method: 'GET',
    path: '/api/bookings/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '6. Bookings',
    ],
  );

  /// GET /api/bookings/1/timeline · Sudz - Customer API · 6. Bookings
  static const AppEndpoint customer6BookingsBookingTimeline = AppEndpoint(
    id: 'customer6BookingsBookingTimeline',
    name: 'Booking Timeline',
    method: 'GET',
    path: '/api/bookings/1/timeline',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '6. Bookings',
    ],
  );

  /// POST /api/bookings/1/cancel · Sudz - Customer API · 6. Bookings
  static const AppEndpoint customer6BookingsCancelBooking = AppEndpoint(
    id: 'customer6BookingsCancelBooking',
    name: 'Cancel Booking',
    method: 'POST',
    path: '/api/bookings/1/cancel',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '6. Bookings',
    ],
  );

  /// POST /api/bookings · Sudz - Customer API · 6. Bookings
  static const AppEndpoint customer6BookingsCreateBooking = AppEndpoint(
    id: 'customer6BookingsCreateBooking',
    name: 'Create Booking',
    method: 'POST',
    path: '/api/bookings',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '6. Bookings',
    ],
  );

  /// GET /api/bookings?status=confirmed · Sudz - Customer API · 6. Bookings
  static const AppEndpoint customer6BookingsListBookings = AppEndpoint(
    id: 'customer6BookingsListBookings',
    name: 'List Bookings',
    method: 'GET',
    path: '/api/bookings?status=confirmed',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '6. Bookings',
    ],
  );

  /// PUT /api/bookings/1/reschedule · Sudz - Customer API · 6. Bookings
  static const AppEndpoint customer6BookingsRescheduleBooking = AppEndpoint(
    id: 'customer6BookingsRescheduleBooking',
    name: 'Reschedule Booking',
    method: 'PUT',
    path: '/api/bookings/1/reschedule',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '6. Bookings',
    ],
  );

  /// POST /api/special-time-requests/1/cancel · Sudz - Customer API · 7. Special Time Requests
  static const AppEndpoint customer7SpecialTimeRequestsCancelRequest = AppEndpoint(
    id: 'customer7SpecialTimeRequestsCancelRequest',
    name: 'Cancel Request',
    method: 'POST',
    path: '/api/special-time-requests/1/cancel',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '7. Special Time Requests',
    ],
  );

  /// GET /api/special-time-requests · Sudz - Customer API · 7. Special Time Requests
  static const AppEndpoint customer7SpecialTimeRequestsListRequests = AppEndpoint(
    id: 'customer7SpecialTimeRequestsListRequests',
    name: 'List Requests',
    method: 'GET',
    path: '/api/special-time-requests',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '7. Special Time Requests',
    ],
  );

  /// POST /api/special-time-requests · Sudz - Customer API · 7. Special Time Requests
  static const AppEndpoint customer7SpecialTimeRequestsSubmitRequest = AppEndpoint(
    id: 'customer7SpecialTimeRequestsSubmitRequest',
    name: 'Submit Request',
    method: 'POST',
    path: '/api/special-time-requests',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '7. Special Time Requests',
    ],
  );

  /// POST /api/ratings/bookings/1/tip · Sudz - Customer API · 8. Ratings & Tips
  static const AppEndpoint customer8RatingsTipsGiveTip = AppEndpoint(
    id: 'customer8RatingsTipsGiveTip',
    name: 'Give Tip',
    method: 'POST',
    path: '/api/ratings/bookings/1/tip',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '8. Ratings & Tips',
    ],
  );

  /// GET /api/ratings/my-ratings · Sudz - Customer API · 8. Ratings & Tips
  static const AppEndpoint customer8RatingsTipsMyRatings = AppEndpoint(
    id: 'customer8RatingsTipsMyRatings',
    name: 'My Ratings',
    method: 'GET',
    path: '/api/ratings/my-ratings',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '8. Ratings & Tips',
    ],
  );

  /// POST /api/ratings/bookings/1/rate · Sudz - Customer API · 8. Ratings & Tips
  static const AppEndpoint customer8RatingsTipsRateBooking = AppEndpoint(
    id: 'customer8RatingsTipsRateBooking',
    name: 'Rate Booking',
    method: 'POST',
    path: '/api/ratings/bookings/1/rate',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '8. Ratings & Tips',
    ],
  );

  /// DELETE /api/notifications/1 · Sudz - Customer API · 9. Notifications
  static const AppEndpoint customer9NotificationsDeleteNotification = AppEndpoint(
    id: 'customer9NotificationsDeleteNotification',
    name: 'Delete Notification',
    method: 'DELETE',
    path: '/api/notifications/1',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '9. Notifications',
    ],
  );

  /// GET /api/notifications · Sudz - Customer API · 9. Notifications
  static const AppEndpoint customer9NotificationsListNotifications = AppEndpoint(
    id: 'customer9NotificationsListNotifications',
    name: 'List Notifications',
    method: 'GET',
    path: '/api/notifications',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '9. Notifications',
    ],
  );

  /// POST /api/notifications/read-all · Sudz - Customer API · 9. Notifications
  static const AppEndpoint customer9NotificationsMarkAllRead = AppEndpoint(
    id: 'customer9NotificationsMarkAllRead',
    name: 'Mark All Read',
    method: 'POST',
    path: '/api/notifications/read-all',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '9. Notifications',
    ],
  );

  /// POST /api/notifications/1/read · Sudz - Customer API · 9. Notifications
  static const AppEndpoint customer9NotificationsMarkAsRead = AppEndpoint(
    id: 'customer9NotificationsMarkAsRead',
    name: 'Mark as Read',
    method: 'POST',
    path: '/api/notifications/1/read',
    collection: 'Sudz - Customer API',
    groupPath: <String>[
      '9. Notifications',
    ],
  );

  /// DELETE /api/auth/delete-account · Sudz - Custom Extensions · 1. Authentication
  static const AppEndpoint sudzcustomextensions1AuthenticationDeleteAccount = AppEndpoint(
    id: 'sudzcustomextensions1AuthenticationDeleteAccount',
    name: 'Delete Account',
    method: 'DELETE',
    path: '/api/auth/delete-account',
    collection: 'Sudz - Custom Extensions',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/reset-password/send-otp · Sudz - Custom Extensions · 1. Authentication
  static const AppEndpoint sudzcustomextensions1AuthenticationResetPasswordSendOtp = AppEndpoint(
    id: 'sudzcustomextensions1AuthenticationResetPasswordSendOtp',
    name: 'Reset Password - Send OTP',
    method: 'POST',
    path: '/api/auth/reset-password/send-otp',
    collection: 'Sudz - Custom Extensions',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/reset-password/set-new-password · Sudz - Custom Extensions · 1. Authentication
  static const AppEndpoint sudzcustomextensions1AuthenticationResetPasswordSetNewPassword = AppEndpoint(
    id: 'sudzcustomextensions1AuthenticationResetPasswordSetNewPassword',
    name: 'Reset Password - Set New Password',
    method: 'POST',
    path: '/api/auth/reset-password/set-new-password',
    collection: 'Sudz - Custom Extensions',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/reset-password/verify-otp · Sudz - Custom Extensions · 1. Authentication
  static const AppEndpoint sudzcustomextensions1AuthenticationResetPasswordVerifyOtp = AppEndpoint(
    id: 'sudzcustomextensions1AuthenticationResetPasswordVerifyOtp',
    name: 'Reset Password - Verify OTP',
    method: 'POST',
    path: '/api/auth/reset-password/verify-otp',
    collection: 'Sudz - Custom Extensions',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// GET /api/auth/profile · Sudz - Technician API · 1. Authentication
  static const AppEndpoint technician1AuthenticationGetProfile = AppEndpoint(
    id: 'technician1AuthenticationGetProfile',
    name: 'Get Profile',
    method: 'GET',
    path: '/api/auth/profile',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/login · Sudz - Technician API · 1. Authentication
  static const AppEndpoint technician1AuthenticationLoginAsTechnician = AppEndpoint(
    id: 'technician1AuthenticationLoginAsTechnician',
    name: 'Login as Technician',
    method: 'POST',
    path: '/api/auth/login',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/auth/logout · Sudz - Technician API · 1. Authentication
  static const AppEndpoint technician1AuthenticationLogout = AppEndpoint(
    id: 'technician1AuthenticationLogout',
    name: 'Logout',
    method: 'POST',
    path: '/api/auth/logout',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '1. Authentication',
    ],
  );

  /// POST /api/technician/badges · Sudz - Technician API · 2. Profile & Performance
  static const AppEndpoint technician2ProfilePerformanceGetBadges = AppEndpoint(
    id: 'technician2ProfilePerformanceGetBadges',
    name: 'Get Badges',
    method: 'POST',
    path: '/api/technician/badges',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '2. Profile & Performance',
    ],
  );

  /// GET /api/technician/performance · Sudz - Technician API · 2. Profile & Performance
  static const AppEndpoint technician2ProfilePerformanceGetPerformanceStats = AppEndpoint(
    id: 'technician2ProfilePerformanceGetPerformanceStats',
    name: 'Get Performance Stats',
    method: 'GET',
    path: '/api/technician/performance',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '2. Profile & Performance',
    ],
  );

  /// GET /api/technician/profile · Sudz - Technician API · 2. Profile & Performance
  static const AppEndpoint technician2ProfilePerformanceGetTechnicianProfile = AppEndpoint(
    id: 'technician2ProfilePerformanceGetTechnicianProfile',
    name: 'Get Technician Profile',
    method: 'GET',
    path: '/api/technician/profile',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '2. Profile & Performance',
    ],
  );

  /// POST /api/technician/availability · Sudz - Technician API · 2. Profile & Performance
  static const AppEndpoint technician2ProfilePerformanceSetAvailability = AppEndpoint(
    id: 'technician2ProfilePerformanceSetAvailability',
    name: 'Set Availability',
    method: 'POST',
    path: '/api/technician/availability',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '2. Profile & Performance',
    ],
  );

  /// POST /api/technician/profile/update · Sudz - Technician API · 2. Profile & Performance
  static const AppEndpoint technician2ProfilePerformanceUpdateProfile = AppEndpoint(
    id: 'technician2ProfilePerformanceUpdateProfile',
    name: 'Update Profile',
    method: 'POST',
    path: '/api/technician/profile/update',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '2. Profile & Performance',
    ],
  );

  /// POST /api/technician/jobs/1/accept · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementAcceptJob = AppEndpoint(
    id: 'technician3JobManagementAcceptJob',
    name: 'Accept Job',
    method: 'POST',
    path: '/api/technician/jobs/1/accept',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// POST /api/technician/jobs/1/complete · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementCompleteJob = AppEndpoint(
    id: 'technician3JobManagementCompleteJob',
    name: 'Complete Job',
    method: 'POST',
    path: '/api/technician/jobs/1/complete',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// GET /api/technician/jobs/1 · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementGetJobDetails = AppEndpoint(
    id: 'technician3JobManagementGetJobDetails',
    name: 'Get Job Details',
    method: 'GET',
    path: '/api/technician/jobs/1',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// GET /api/technician/jobs?filter=assigned · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementListAssignedJobs = AppEndpoint(
    id: 'technician3JobManagementListAssignedJobs',
    name: 'List Assigned Jobs',
    method: 'GET',
    path: '/api/technician/jobs?filter=assigned',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// GET /api/technician/jobs?filter=available · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementListAvailableJobs = AppEndpoint(
    id: 'technician3JobManagementListAvailableJobs',
    name: 'List Available Jobs',
    method: 'GET',
    path: '/api/technician/jobs?filter=available',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// GET /api/technician/jobs?filter=in_progress · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementListInProgressJobs = AppEndpoint(
    id: 'technician3JobManagementListInProgressJobs',
    name: 'List In Progress Jobs',
    method: 'GET',
    path: '/api/technician/jobs?filter=in_progress',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// GET /api/technician/jobs?filter=today · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementListTodaySJobs = AppEndpoint(
    id: 'technician3JobManagementListTodaySJobs',
    name: 'List Today\'s Jobs',
    method: 'GET',
    path: '/api/technician/jobs?filter=today',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// POST /api/technician/jobs/1/arrive · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementMarkArrival = AppEndpoint(
    id: 'technician3JobManagementMarkArrival',
    name: 'Mark Arrival',
    method: 'POST',
    path: '/api/technician/jobs/1/arrive',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// POST /api/technician/jobs/1/reject · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementRejectJob = AppEndpoint(
    id: 'technician3JobManagementRejectJob',
    name: 'Reject Job',
    method: 'POST',
    path: '/api/technician/jobs/1/reject',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// POST /api/technician/jobs/1/start · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementStartJob = AppEndpoint(
    id: 'technician3JobManagementStartJob',
    name: 'Start Job',
    method: 'POST',
    path: '/api/technician/jobs/1/start',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// POST /api/technician/jobs/1/upload-evidence · Sudz - Technician API · 3. Job Management
  static const AppEndpoint technician3JobManagementUploadEvidencePhotos = AppEndpoint(
    id: 'technician3JobManagementUploadEvidencePhotos',
    name: 'Upload Evidence Photos',
    method: 'POST',
    path: '/api/technician/jobs/1/upload-evidence',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '3. Job Management',
    ],
  );

  /// GET /api/technician/earnings/1 · Sudz - Technician API · 4. Earnings & Tips
  static const AppEndpoint technician4EarningsTipsGetEarningDetails = AppEndpoint(
    id: 'technician4EarningsTipsGetEarningDetails',
    name: 'Get Earning Details',
    method: 'GET',
    path: '/api/technician/earnings/1',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '4. Earnings & Tips',
    ],
  );

  /// GET /api/technician/earnings · Sudz - Technician API · 4. Earnings & Tips
  static const AppEndpoint technician4EarningsTipsGetEarningsSummary = AppEndpoint(
    id: 'technician4EarningsTipsGetEarningsSummary',
    name: 'Get Earnings Summary',
    method: 'GET',
    path: '/api/technician/earnings',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '4. Earnings & Tips',
    ],
  );

  /// GET /api/technician/earnings?status=paid · Sudz - Technician API · 4. Earnings & Tips
  static const AppEndpoint technician4EarningsTipsGetPaidEarnings = AppEndpoint(
    id: 'technician4EarningsTipsGetPaidEarnings',
    name: 'Get Paid Earnings',
    method: 'GET',
    path: '/api/technician/earnings?status=paid',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '4. Earnings & Tips',
    ],
  );

  /// GET /api/technician/earnings?period=month · Sudz - Technician API · 4. Earnings & Tips
  static const AppEndpoint technician4EarningsTipsGetThisMonthEarnings = AppEndpoint(
    id: 'technician4EarningsTipsGetThisMonthEarnings',
    name: 'Get This Month Earnings',
    method: 'GET',
    path: '/api/technician/earnings?period=month',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '4. Earnings & Tips',
    ],
  );

  /// GET /api/technician/earnings/tips/received · Sudz - Technician API · 4. Earnings & Tips
  static const AppEndpoint technician4EarningsTipsGetTipsReceived = AppEndpoint(
    id: 'technician4EarningsTipsGetTipsReceived',
    name: 'Get Tips Received',
    method: 'GET',
    path: '/api/technician/earnings/tips/received',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '4. Earnings & Tips',
    ],
  );

  /// POST /api/technician/sync · Sudz - Technician API · 5. Offline Sync
  static const AppEndpoint technician5OfflineSyncSyncOfflineActions = AppEndpoint(
    id: 'technician5OfflineSyncSyncOfflineActions',
    name: 'Sync Offline Actions',
    method: 'POST',
    path: '/api/technician/sync',
    collection: 'Sudz - Technician API',
    groupPath: <String>[
      '5. Offline Sync',
    ],
  );

  static const List<AppEndpoint> values = <AppEndpoint>[
    customer10AppContentAboutUs,
    customer10AppContentContactInfo,
    customer10AppContentFaq,
    customer10AppContentPrivacyPolicy,
    customer10AppContentTermsConditions,
    customer1AuthenticationChangePassword,
    customer1AuthenticationEditProfile,
    customer1AuthenticationGetProfile,
    customer1AuthenticationLogin,
    customer1AuthenticationLogout,
    customer1AuthenticationRegister,
    customer1AuthenticationVerifyPhone,
    customer2AddressesCreateAddress,
    customer2AddressesDeleteAddress,
    customer2AddressesListAddresses,
    customer2AddressesSetDefaultAddress,
    customer2AddressesUpdateAddress,
    customer3CarsAddCar,
    customer3CarsDeleteCar,
    customer3CarsGetCarSizes,
    customer3CarsListCars,
    customer3CarsSetPrimaryCar,
    customer3CarsUpdateCar,
    customer4ServicesBrowseServices,
    customer4ServicesListServiceCategories,
    customer4ServicesServiceDetails,
    customer5PackagesListPackages,
    customer5PackagesMyActivePackages,
    customer5PackagesPackageDetails,
    customer5PackagesPurchasePackage,
    customer6BookingsBookingDetails,
    customer6BookingsBookingTimeline,
    customer6BookingsCancelBooking,
    customer6BookingsCreateBooking,
    customer6BookingsListBookings,
    customer6BookingsRescheduleBooking,
    customer7SpecialTimeRequestsCancelRequest,
    customer7SpecialTimeRequestsListRequests,
    customer7SpecialTimeRequestsSubmitRequest,
    customer8RatingsTipsGiveTip,
    customer8RatingsTipsMyRatings,
    customer8RatingsTipsRateBooking,
    customer9NotificationsDeleteNotification,
    customer9NotificationsListNotifications,
    customer9NotificationsMarkAllRead,
    customer9NotificationsMarkAsRead,
    sudzcustomextensions1AuthenticationDeleteAccount,
    sudzcustomextensions1AuthenticationResetPasswordSendOtp,
    sudzcustomextensions1AuthenticationResetPasswordSetNewPassword,
    sudzcustomextensions1AuthenticationResetPasswordVerifyOtp,
    technician1AuthenticationGetProfile,
    technician1AuthenticationLoginAsTechnician,
    technician1AuthenticationLogout,
    technician2ProfilePerformanceGetBadges,
    technician2ProfilePerformanceGetPerformanceStats,
    technician2ProfilePerformanceGetTechnicianProfile,
    technician2ProfilePerformanceSetAvailability,
    technician2ProfilePerformanceUpdateProfile,
    technician3JobManagementAcceptJob,
    technician3JobManagementCompleteJob,
    technician3JobManagementGetJobDetails,
    technician3JobManagementListAssignedJobs,
    technician3JobManagementListAvailableJobs,
    technician3JobManagementListInProgressJobs,
    technician3JobManagementListTodaySJobs,
    technician3JobManagementMarkArrival,
    technician3JobManagementRejectJob,
    technician3JobManagementStartJob,
    technician3JobManagementUploadEvidencePhotos,
    technician4EarningsTipsGetEarningDetails,
    technician4EarningsTipsGetEarningsSummary,
    technician4EarningsTipsGetPaidEarnings,
    technician4EarningsTipsGetThisMonthEarnings,
    technician4EarningsTipsGetTipsReceived,
    technician5OfflineSyncSyncOfflineActions,
  ];
}
