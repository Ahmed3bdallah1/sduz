import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/features/address/domain/entities/user_address.dart'
    as address_models;
import 'package:sudz/features/auth/ui/pages/pages.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/features/car/models/models.dart' as car_models;
import 'package:sudz/features/car/ui/pages/pages.dart';
import 'package:sudz/features/home/ui/pages/pages.dart';
import 'package:sudz/features/orders/ui/pages/pages.dart';
import 'package:sudz/features/service/ui/pages/pages.dart';
import 'package:sudz/features/service/checkout_selection/models/models.dart';
import 'package:sudz/features/service/checkout_selection/ui/pages/pages.dart';
import 'package:sudz/features/service/models/models.dart' as service_models;
import 'package:sudz/features/service/schedule/models/models.dart'
    as service_schedule_models;
import 'package:sudz/features/service/schedule/ui/pages/pages.dart';
import 'package:sudz/features/splash/ui/pages/pages.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/features/store/home/ui/pages/pages.dart';
import 'package:sudz/features/store/category/ui/pages/pages.dart';
import 'package:sudz/features/store/product/ui/pages/pages.dart';
import 'package:sudz/features/store/cart/ui/pages/pages.dart';
import 'package:sudz/features/store/checkout/ui/pages/pages.dart';
import 'package:sudz/features/store/order_confirmation/ui/pages/pages.dart';
import 'package:sudz/features/profile/home/ui/pages/pages.dart';
import 'package:sudz/features/profile/my_cars/ui/pages/pages.dart';
import 'package:sudz/features/profile/my_packages/ui/pages/pages.dart';
import 'package:sudz/features/profile/dedication/ui/pages/pages.dart';
import 'package:sudz/features/signup/ui/pages/pages.dart';
import 'package:sudz/features/packages/all_packages/ui/pages/pages.dart';
import 'package:sudz/features/packages/checkout/ui/pages/pages.dart';
import 'package:sudz/features/packages/confirmation/ui/pages/pages.dart';
import 'package:sudz/features/packages/data/models/package.dart';
import 'package:sudz/features/tech/home/ui/pages/pages.dart';
import 'package:sudz/features/tech/jobs/models/models.dart';
import 'package:sudz/features/tech/jobs/ui/pages/pages.dart';
import 'package:sudz/features/auth/bloc/role_selection_cubit.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SplashPage()),
      ),

      GoRoute(
        path: RouteNames.roleSelection,
        name: RouteNames.roleSelection,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: getIt<RoleSelectionCubit>()..unlockRole(),
            child: const RoleSelectionPage(),
          ),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: getIt<RoleSelectionCubit>(),
            child: const LoginPage(),
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: RouteNames.signup,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: getIt<RoleSelectionCubit>(),
            child: const SignupPage(),
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.verifyPhone,
        name: RouteNames.verifyPhone,
        pageBuilder: (context, state) {
          final args = state.extra as VerifyPhoneArgs?;
          final child = args == null
              ? const _MissingVerifyPhoneArgsPage()
              : VerifyPhonePage(args: args);
          return MaterialPage(key: state.pageKey, child: child);
        },
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: Container(), // TODO: Replace with RegisterScreen
        ),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPassword,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: Container(), // TODO: Replace with ForgotPasswordScreen
        ),
      ),

      // Main Routes
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const HomePage()),
      ),
      GoRoute(
        path: RouteNames.techHome,
        name: RouteNames.techHome,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const TechHomePage()),
      ),
      GoRoute(
        path: RouteNames.techJobDetails,
        name: RouteNames.techJobDetails,
        pageBuilder: (context, state) {
          final job = state.extra as TechJob?;
          final child = job == null
              ? const _MissingTechJobScreen()
              : TechJobDetailsPage(job: job);
          return MaterialPage(key: state.pageKey, child: child);
        },
      ),
      GoRoute(
        path: RouteNames.orders,
        name: RouteNames.orders,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const OrdersPage()),
      ),
      GoRoute(
        path: RouteNames.service,
        name: RouteNames.service,
        pageBuilder: (context, state) {
          final initialServiceTypeId = state.extra as String?;
          return MaterialPage(
            key: state.pageKey,
            child: ServicePage(initialServiceTypeId: initialServiceTypeId),
          );
        },
      ),
      GoRoute(
        path: RouteNames.serviceCheckoutSelection,
        name: RouteNames.serviceCheckoutSelection,
        pageBuilder: (context, state) {
          final params = state.extra as ServiceCheckoutSelectionParams?;

          final child = params == null
              ? _MissingCheckoutParamsScreen()
              : ServiceCheckoutSelectionPage(params: params);

          return MaterialPage(key: state.pageKey, child: child);
        },
      ),
      GoRoute(
        path: RouteNames.serviceCheckoutSingle,
        name: RouteNames.serviceCheckoutSingle,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          
          if (extra == null) {
            return MaterialPage(
              key: state.pageKey,
              child: _MissingCheckoutParamsScreen(),
            );
          }

          final serviceType = extra['serviceType'] as service_models.ServiceType?;
          final car = extra['car'] as car_models.ServiceCar?;
          final address = extra['address'] as address_models.UserAddress?;
          final scheduleSelection = extra['scheduleSelection'] as service_schedule_models.ServiceScheduleSelection?;
          final activePackage = extra['activePackage'] as service_models.ServicePackage?;

          final child = (serviceType == null || car == null || address == null || scheduleSelection == null)
              ? _MissingCheckoutParamsScreen()
              : ServiceCheckoutSinglePage(
                  serviceType: serviceType,
                  car: car,
                  address: address,
                  scheduleSelection: scheduleSelection,
                  activePackage: activePackage,
                );

          return MaterialPage(key: state.pageKey, child: child);
        },
      ),
      GoRoute(
        path: RouteNames.serviceCheckoutPackage,
        name: RouteNames.serviceCheckoutPackage,
        pageBuilder: (context, state) {
          final package = state.extra as service_models.ServicePackage?;
          final child = package == null
              ? _MissingCheckoutParamsScreen()
              : ServiceCheckoutPackagePage(package: package);

          return MaterialPage(key: state.pageKey, child: child);
        },
      ),
      GoRoute(
        path: RouteNames.serviceSchedule,
        name: RouteNames.serviceSchedule,
        pageBuilder: (context, state) {
          final params = state.extra as service_schedule_models.ServiceScheduleParams?;
          final child = params == null
              ? _MissingCheckoutParamsScreen()
              : ServiceSchedulePage(params: params);

          return MaterialPage(key: state.pageKey, child: child);
        },
      ),
      GoRoute(
        path: RouteNames.store,
        name: RouteNames.store,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const StoreHomePage()),
      ),
      GoRoute(
        path: RouteNames.packages,
        name: RouteNames.packages,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const PackagesPage()),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ProfileHomePage()),
      ),
      GoRoute(
        path: RouteNames.profileCars,
        name: RouteNames.profileCars,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const MyCarsPage()),
      ),
      GoRoute(
        path: RouteNames.profilePackages,
        name: RouteNames.profilePackages,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const MyPackagesPage()),
      ),
      GoRoute(
        path: RouteNames.profileDedication,
        name: RouteNames.profileDedication,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const DedicationPage()),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: Container(), // TODO: Replace with SettingsScreen
        ),
      ),

      // Feature Routes
      GoRoute(
        path: RouteNames.details,
        name: RouteNames.details,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: Container(), // TODO: Replace with DetailsScreen
        ),
      ),
      GoRoute(
        path: RouteNames.search,
        name: RouteNames.search,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: Container(), // TODO: Replace with SearchScreen
        ),
      ),
      GoRoute(
        path: RouteNames.addCar,
        name: RouteNames.addCar,
        pageBuilder: (context, state) {
          final initialCar = state.extra as UserCar?;
          return MaterialPage(
            key: state.pageKey,
            child: AddCarPage(initialCar: initialCar),
          );
        },
      ),
      GoRoute(
        path: RouteNames.storeCategory,
        name: RouteNames.storeCategory,
        pageBuilder: (context, state) {
          final category = state.extra as StoreCategory;
          return MaterialPage(
            key: state.pageKey,
            child: StoreCategoryPage(category: category),
          );
        },
      ),
      GoRoute(
        path: RouteNames.storeProduct,
        name: RouteNames.storeProduct,
        pageBuilder: (context, state) {
          final product = state.extra as StoreProduct;
          return MaterialPage(
            key: state.pageKey,
            child: StoreProductPage(product: product),
          );
        },
      ),
      GoRoute(
        path: RouteNames.storeCart,
        name: RouteNames.storeCart,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const StoreCartPage()),
      ),
      GoRoute(
        path: RouteNames.storeCheckout,
        name: RouteNames.storeCheckout,
        pageBuilder: (context, state) {
          final total = state.extra as double? ?? 0;
          return MaterialPage(
            key: state.pageKey,
            child: StoreCheckoutPage(total: total),
          );
        },
      ),
      GoRoute(
        path: RouteNames.storeOrderConfirmation,
        name: RouteNames.storeOrderConfirmation,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const StoreOrderConfirmationPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.packagesCheckout,
        name: RouteNames.packagesCheckout,
        pageBuilder: (context, state) {
          final package = state.extra as Package?;
          return MaterialPage(
            key: state.pageKey,
            child: package == null
                ? const PackagesPage()
                : PackageCheckoutPage(package: package),
          );
        },
      ),
      GoRoute(
        path: RouteNames.packagesConfirmation,
        name: RouteNames.packagesConfirmation,
        pageBuilder: (context, state) {
          final package = state.extra as Package?;
          return MaterialPage(
            key: state.pageKey,
            child: package == null
                ? const PackagesPage()
                : PackageConfirmationPage(package: package),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      ),
    ),
  );
}

class _MissingCheckoutParamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('service.checkout.error_missing_params'.tr())),
      body: Center(
        child: Text(
          'service.checkout.error_missing_params'.tr(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MissingTechJobScreen extends StatelessWidget {
  const _MissingTechJobScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job unavailable')),
      body: const Center(
        child: Text(
          'We could not find details for that job. Please reopen from the jobs list.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MissingVerifyPhoneArgsPage extends StatelessWidget {
  const _MissingVerifyPhoneArgsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('auth.verify_phone.title'.tr())),
      body: Center(
        child: Text(
          'auth.verify_phone.missing_arguments'.tr(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
