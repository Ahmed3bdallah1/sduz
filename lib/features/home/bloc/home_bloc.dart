import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/features/home/models/models.dart';
import 'package:sudz/features/packages/domain/repositories/packages_repository.dart';
import 'package:sudz/features/service/domain/entities/service.dart';
import 'package:sudz/features/service/domain/repositories/service_repository.dart';
import 'package:sudz/features/packages/domain/entities/user_package.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    ServiceRepository? serviceRepository,
    PackagesRepository? packagesRepository,
  })  : _serviceRepository = serviceRepository,
        _packagesRepository = packagesRepository,
        super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeBottomNavChanged>(_onBottomNavChanged);
  }

  final ServiceRepository? _serviceRepository;
  final PackagesRepository? _packagesRepository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Fetch service categories and services from API if available
      List<HomeCategory> categories;
      List<Service> services = [];
      List<HomePackage> packages = [];

      if (_serviceRepository != null) {
        try {
          final serviceCategories = await _serviceRepository.fetchServiceCategories();
          categories = serviceCategories
              .map((category) => HomeCategory.fromServiceCategory(category))
              .toList();

          // Fetch services as well
          try {
            services = await _serviceRepository.fetchServices();
          } catch (e) {
            // Services fetch failed, continue with empty list
            services = [];
          }
        } catch (e) {
          // Fallback to default categories if API fails
          categories = _initialCategories;
        }
      } else {
        categories = _initialCategories;
      }

      // Fetch packages from API if available
      List<UserPackage> userPackages = [];
      if (_packagesRepository != null) {
        try {
          final apiPackages = await _packagesRepository.fetchPackages();
          packages = apiPackages
              .map((pkg) => HomePackage.fromPackage(pkg))
              .toList();
          try {
            userPackages = await _packagesRepository.fetchMyActivePackages();
          } catch (_) {}
        } catch (e) {
          // Fallback to mock packages if API fails
          packages = _initialPackages;
        }
      } else {
        packages = _initialPackages;
      }

      final featured = packages.isNotEmpty ? packages.first : null;

      emit(
        state.copyWith(
          status: HomeStatus.success,
          categories: categories,
          selectedCategoryId: categories.isNotEmpty ? categories.first.id : null,
          overrideSelectedCategory: true,
          packages: packages,
          services: services,
          featuredPackage: featured,
          activeUserPackage: _pickActive(userPackages),
          overrideActiveUserPackage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        selectedCategoryId: event.categoryId,
        overrideSelectedCategory: true,
      ),
    );
  }

  void _onBottomNavChanged(
    HomeBottomNavChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(bottomNavIndex: event.index));
  }

  UserPackage? _pickActive(List<UserPackage> packages) {
    if (packages.isEmpty) return null;
    for (final pkg in packages) {
      if (pkg.isActive) return pkg;
    }
    return packages.first;
  }
}

final List<HomeCategory> _initialCategories = [
  HomeCategory(
    id: 'wash',
    title: 'غسيل',
    icon: Icons.local_car_wash_outlined,
    backgroundColor: const Color(0xFFEFE5FF),
  ),
  HomeCategory(
    id: 'polish',
    title: 'تلميع',
    icon: Icons.auto_fix_high_outlined,
    backgroundColor: const Color(0xFFE1F2FF),
  ),
  HomeCategory(
    id: 'maintenance',
    title: 'صيانة',
    icon: Icons.build_outlined,
    backgroundColor: const Color(0xFFFFF0E6),
  ),
  HomeCategory(
    id: 'other',
    title: 'اخرى',
    icon: Icons.more_horiz,
    backgroundColor: const Color(0xFFF0F4F8),
  ),
];

final List<HomePackage> _initialPackages = [
  HomePackage(
    id: 'premium-wash',
    title: 'غسيل فاخر',
    imageUrl:
        'https://images.unsplash.com/photo-1619767886558-efdc259cde1a?auto=format&fit=crop&w=900&q=80',
    price: 200,
    priceUnit: 'ريال',
    description: 'غسيل كامل مع تلميع داخلي وخارجي.',
    ordersCount: 28,
    durationMinutes: 60,
  ),
  HomePackage(
    id: 'quick-wash',
    title: 'غسيل سريع',
    imageUrl:
        'https://images.unsplash.com/photo-1549921296-3cc892f48577?auto=format&fit=crop&w=900&q=80',
    price: 120,
    priceUnit: 'ريال',
    description: 'تنظيف خارجي سريع مع تجفيف كامل.',
    ordersCount: 18,
    durationMinutes: 30,
  ),
  HomePackage(
    id: 'ceramic',
    title: 'حماية سيراميك',
    imageUrl:
        'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?auto=format&fit=crop&w=900&q=80',
    price: 300,
    priceUnit: 'ريال',
    description: 'حماية جسم السيارة بطبقة سيراميك تدوم طويلاً.',
    ordersCount: 12,
    durationMinutes: 90,
  ),
];
