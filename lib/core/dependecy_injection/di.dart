import 'package:get_it/get_it.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'package:sudz/core/network/auth_token_provider.dart';
import 'package:sudz/core/network/dio_client.dart';
import 'package:sudz/core/network/shared_prefs_auth_token_provider.dart';
import 'package:sudz/features/address/bloc/address_bloc.dart';
import 'package:sudz/features/address/data/datasources/address_remote_data_source.dart';
import 'package:sudz/features/address/data/repositories/address_repository_impl.dart';
import 'package:sudz/features/address/domain/repositories/address_repository.dart';
import 'package:sudz/features/auth/bloc/login_bloc.dart';
import 'package:sudz/features/auth/bloc/role_selection_cubit.dart';
import 'package:sudz/features/auth/bloc/verify_phone_bloc.dart';
import 'package:sudz/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sudz/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sudz/features/auth/domain/repositories/auth_repository.dart';
import 'package:sudz/features/car/bloc/bloc.dart';
import 'package:sudz/features/car/data/datasources/car_remote_data_source.dart';
import 'package:sudz/features/car/data/repositories/car_repository_impl.dart';
import 'package:sudz/features/car/domain/repositories/car_repository.dart';
import 'package:sudz/features/home/bloc/home_bloc.dart';
import 'package:sudz/features/orders/bloc/bloc.dart';
import 'package:sudz/features/packages/all_packages/bloc/bloc.dart';
import 'package:sudz/features/packages/checkout/bloc/bloc.dart';
import 'package:sudz/features/packages/data/datasources/packages_remote_data_source.dart';
import 'package:sudz/features/packages/data/repositories/packages_repository_impl.dart';
import 'package:sudz/features/packages/domain/repositories/packages_repository.dart';
import 'package:sudz/features/profile/dedication/bloc/bloc.dart';
import 'package:sudz/features/profile/home/bloc/bloc.dart';
import 'package:sudz/features/profile/my_cars/bloc/bloc.dart';
import 'package:sudz/features/profile/my_packages/bloc/bloc.dart';
import 'package:sudz/features/profile/my_packages/data/my_packages_repository.dart';
import 'package:sudz/features/address/domain/entities/user_address.dart';
import 'package:sudz/features/car/models/service_car.dart';
import 'package:sudz/features/service/bloc/bloc.dart';
import 'package:sudz/features/service/checkout_selection/bloc/bloc.dart';
import 'package:sudz/features/service/checkout_selection/models/models.dart';
import 'package:sudz/features/service/data/datasources/booking_remote_data_source.dart';
import 'package:sudz/features/service/data/datasources/service_remote_data_source.dart';
import 'package:sudz/features/service/data/datasources/special_time_request_remote_data_source.dart';
import 'package:sudz/features/service/data/repositories/booking_repository_impl.dart';
import 'package:sudz/features/service/data/repositories/service_repository_impl.dart';
import 'package:sudz/features/service/data/repositories/special_time_request_repository_impl.dart';
import 'package:sudz/features/service/domain/repositories/booking_repository.dart';
import 'package:sudz/features/service/domain/repositories/service_repository.dart';
import 'package:sudz/features/service/domain/repositories/special_time_request_repository.dart';
import 'package:sudz/features/service/models/models.dart';
import 'package:sudz/features/service/schedule/bloc/bloc.dart';
import 'package:sudz/features/service/schedule/models/models.dart';
import 'package:sudz/features/signup/bloc/signup_bloc.dart';
import 'package:sudz/features/store/cart/bloc/bloc.dart';
import 'package:sudz/features/store/category/bloc/bloc.dart';
import 'package:sudz/features/store/checkout/bloc/bloc.dart';
import 'package:sudz/features/store/home/bloc/bloc.dart';
import 'package:sudz/features/store/order_confirmation/bloc/bloc.dart';
import 'package:sudz/features/store/product/bloc/bloc.dart';
import 'package:sudz/features/tech/home/bloc/bloc.dart';
import 'package:sudz/features/tech/jobs/bloc/bloc.dart';
import 'package:sudz/features/tech/jobs/models/tech_job.dart';
import 'package:sudz/features/tech/jobs/data/datasources/tech_jobs_remote_data_source.dart';
import 'package:sudz/features/tech/jobs/data/repositories/tech_jobs_repository_impl.dart';
import 'package:sudz/features/tech/jobs/domain/repositories/tech_jobs_repository.dart';
import 'package:sudz/features/ratings/data/datasources/ratings_remote_data_source.dart';
import 'package:sudz/features/ratings/data/repositories/ratings_repository_impl.dart';
import 'package:sudz/features/ratings/domain/repositories/ratings_repository.dart';
import 'package:sudz/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:sudz/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:sudz/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:sudz/features/app_content/data/datasources/app_content_remote_data_source.dart';
import 'package:sudz/features/app_content/data/repositories/app_content_repository_impl.dart';
import 'package:sudz/features/app_content/domain/repositories/app_content_repository.dart';

final getIt = GetIt.instance;

void setup({required LocalDatabaseService localDatabase}) {
  // Core Services
  _setupCoreServices(localDatabase);

  // Address Feature
  _setupAddress();

  // Auth Feature
  _setupAuth();

  // Car Feature
  _setupCar();

  // Home Feature
  _setupHome();

  // Service Feature
  _setupService();

  // Special Time Requests
  _setupSpecialTimeRequests();

  // Ratings & Tips
  _setupRatings();

  // Orders Feature
  _setupOrders();

  // Notifications
  _setupNotifications();

  // App Content
  _setupAppContent();

  // Store Feature
  _setupStore();

  // Packages Feature
  _setupPackages();

  // Profile Feature
  _setupProfile();

  // Technician Feature
  _setupTech();
}

void _setupAddress() {
  if (!getIt.isRegistered<AddressRemoteDataSource>()) {
    getIt.registerLazySingleton<AddressRemoteDataSource>(
      () => AddressRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<AddressRepository>()) {
    getIt.registerLazySingleton<AddressRepository>(
      () => AddressRepositoryImpl(getIt<AddressRemoteDataSource>()),
    );
  }

  getIt.registerFactory<AddressBloc>(
    () => AddressBloc(getIt<AddressRepository>()),
  );
}

void _setupCoreServices(LocalDatabaseService localDatabase) {
  if (!getIt.isRegistered<LocalDatabaseService>()) {
    getIt.registerSingleton<LocalDatabaseService>(localDatabase);
  }
  if (!getIt.isRegistered<AuthTokenProvider>()) {
    getIt.registerLazySingleton<AuthTokenProvider>(
      () => SharedPrefsAuthTokenProvider(getIt<LocalDatabaseService>()),
    );
  }
  if (!getIt.isRegistered<DioClient>()) {
    getIt.registerLazySingleton<DioClient>(
      () => DioClient(tokenProvider: getIt<AuthTokenProvider>()),
    );
  }
}

void _setupAuth() {
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt<AuthRemoteDataSource>(),
        getIt<AuthTokenProvider>(),
      ),
    );
  }

  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt<AuthRepository>()));

  // Register SignupBloc as Factory (new instance each time)
  getIt.registerFactory<SignupBloc>(() => SignupBloc(getIt<AuthRepository>()));

  getIt.registerFactoryParam<VerifyPhoneBloc, String, void>(
    (phone, _) =>
        VerifyPhoneBloc(authRepository: getIt<AuthRepository>(), phone: phone),
  );

  // Role selection cubit shared across auth flow
  getIt.registerLazySingleton<RoleSelectionCubit>(
    () => RoleSelectionCubit(getIt<LocalDatabaseService>()),
  );

  // TODO: Register repositories when created
  // getIt.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(getIt<DioClient>()),
  // );
}

void _setupHome() {
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      serviceRepository: getIt<ServiceRepository>(),
      packagesRepository: getIt<PackagesRepository>(),
    ),
  );
}

void _setupService() {
  if (!getIt.isRegistered<ServiceRemoteDataSource>()) {
    getIt.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<ServiceRepository>()) {
    getIt.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(getIt<ServiceRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<BookingRemoteDataSource>()) {
    getIt.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<BookingRepository>()) {
    getIt.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(getIt<BookingRemoteDataSource>()),
    );
  }

  getIt
    ..registerFactory<ServiceBloc>(
      () => ServiceBloc(
        carRepository: getIt<CarRepository>(),
        serviceRepository: getIt<ServiceRepository>(),
        packagesRepository: getIt<PackagesRepository>(),
      ),
    )
    ..registerFactoryParam<
      ServiceCheckoutSelectionBloc,
      ServiceCheckoutSelectionParams,
      void
    >((params, _) => ServiceCheckoutSelectionBloc(params: params))
    ..registerFactory<ServiceScheduleBloc>(() => ServiceScheduleBloc())
    ..registerFactory<
      ServiceCheckoutBloc Function({
        required ServiceType serviceType,
        required ServiceCar car,
        required UserAddress address,
        required ServiceScheduleSelection scheduleSelection,
        ServicePackage? activePackage,
      })
    >(
      () => ({
        required ServiceType serviceType,
        required ServiceCar car,
        required UserAddress address,
        required ServiceScheduleSelection scheduleSelection,
        ServicePackage? activePackage,
      }) =>
          ServiceCheckoutBloc(
        bookingRepository: getIt<BookingRepository>(),
        serviceType: serviceType,
        car: car,
        address: address,
        scheduleSelection: scheduleSelection,
        activePackage: activePackage,
      ),
    );
}

void _setupSpecialTimeRequests() {
  if (!getIt.isRegistered<SpecialTimeRequestRemoteDataSource>()) {
    getIt.registerLazySingleton<SpecialTimeRequestRemoteDataSource>(
      () => SpecialTimeRequestRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<SpecialTimeRequestRepository>()) {
    getIt.registerLazySingleton<SpecialTimeRequestRepository>(
      () => SpecialTimeRequestRepositoryImpl(
        getIt<SpecialTimeRequestRemoteDataSource>(),
      ),
    );
  }
}

void _setupRatings() {
  if (!getIt.isRegistered<RatingsRemoteDataSource>()) {
    getIt.registerLazySingleton<RatingsRemoteDataSource>(
      () => RatingsRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<RatingsRepository>()) {
    getIt.registerLazySingleton<RatingsRepository>(
      () => RatingsRepositoryImpl(getIt<RatingsRemoteDataSource>()),
    );
  }
}

void _setupCar() {
  if (!getIt.isRegistered<CarRemoteDataSource>()) {
    getIt.registerLazySingleton<CarRemoteDataSource>(
      () => CarRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<CarRepository>()) {
    getIt.registerLazySingleton<CarRepository>(
      () => CarRepositoryImpl(getIt<CarRemoteDataSource>()),
    );
  }

  getIt.registerFactory<AddCarBloc>(
    () => AddCarBloc(carRepository: getIt<CarRepository>()),
  );
}

void _setupOrders() {
  getIt.registerFactory<OrdersBloc>(
    () => OrdersBloc(bookingRepository: getIt<BookingRepository>()),
  );
}

void _setupNotifications() {
  if (!getIt.isRegistered<NotificationsRemoteDataSource>()) {
    getIt.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<NotificationsRepository>()) {
    getIt.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        getIt<NotificationsRemoteDataSource>(),
      ),
    );
  }
}

void _setupAppContent() {
  if (!getIt.isRegistered<AppContentRemoteDataSource>()) {
    getIt.registerLazySingleton<AppContentRemoteDataSource>(
      () => AppContentRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<AppContentRepository>()) {
    getIt.registerLazySingleton<AppContentRepository>(
      () => AppContentRepositoryImpl(
        getIt<AppContentRemoteDataSource>(),
      ),
    );
  }
}

void _setupStore() {
  getIt
    ..registerFactory<StoreHomeBloc>(() => StoreHomeBloc())
    ..registerFactory<StoreCategoryBloc>(() => StoreCategoryBloc())
    ..registerFactory<StoreProductBloc>(() => StoreProductBloc())
    ..registerFactory<StoreCartBloc>(() => StoreCartBloc())
    ..registerFactory<StoreCheckoutBloc>(() => StoreCheckoutBloc())
    ..registerFactory<StoreOrderConfirmationBloc>(
      () => StoreOrderConfirmationBloc(),
    );
}

void _setupPackages() {
  if (!getIt.isRegistered<PackagesRemoteDataSource>()) {
    getIt.registerLazySingleton<PackagesRemoteDataSource>(
      () => PackagesRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<PackagesRepository>()) {
    getIt.registerLazySingleton<PackagesRepository>(
      () => PackagesRepositoryImpl(getIt<PackagesRemoteDataSource>()),
    );
  }

  getIt
    ..registerFactory<PackagesBloc>(
      () => PackagesBloc(repository: getIt<PackagesRepository>()),
    )
    ..registerFactory<PackageCheckoutBloc>(
      () => PackageCheckoutBloc(
        packagesRepository: getIt<PackagesRepository>(),
      ),
    );
}

void _setupProfile() {
  if (!getIt.isRegistered<MyPackagesRepository>()) {
    getIt.registerLazySingleton<MyPackagesRepository>(
      () => MyPackagesRepository(getIt<PackagesRepository>()),
    );
  }

  getIt
    ..registerFactory<ProfileHomeBloc>(() => ProfileHomeBloc())
    ..registerFactory<MyCarsBloc>(
      () => MyCarsBloc(carRepository: getIt<CarRepository>()),
    )
    ..registerFactory<MyPackagesBloc>(
      () => MyPackagesBloc(repository: getIt<MyPackagesRepository>()),
    )
    ..registerFactory<DedicationBloc>(() => DedicationBloc());
}

void _setupTech() {
  if (!getIt.isRegistered<TechJobsRemoteDataSource>()) {
    getIt.registerLazySingleton<TechJobsRemoteDataSource>(
      () => TechJobsRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<TechJobsRepository>()) {
    getIt.registerLazySingleton<TechJobsRepository>(
      () => TechJobsRepositoryImpl(getIt<TechJobsRemoteDataSource>()),
    );
  }

  getIt
    ..registerFactory<TechHomeBloc>(() => TechHomeBloc())
    ..registerFactory<TechJobsBloc>(
      () => TechJobsBloc(repository: getIt<TechJobsRepository>()),
    )
    ..registerFactoryParam<TechJobDetailsBloc, TechJob, void>(
      (job, _) => TechJobDetailsBloc(
        job: job,
        repository: getIt<TechJobsRepository>(),
      ),
    );
}
