import 'package:equatable/equatable.dart';
import 'package:sudz/features/home/models/models.dart';
import 'package:sudz/features/service/domain/entities/service.dart';
import 'package:sudz/features/packages/domain/entities/user_package.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<HomeCategory> categories;
  final String? selectedCategoryId;
  final HomePackage? featuredPackage;
  final List<HomePackage> packages;
  final List<Service> services;
  final int bottomNavIndex;
  final String? errorMessage;
  final UserPackage? activeUserPackage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.selectedCategoryId,
    this.featuredPackage,
    this.packages = const [],
    this.services = const [],
    this.bottomNavIndex = 0,
    this.errorMessage,
    this.activeUserPackage,
  });

  List<Service> get filteredServices {
    if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
      return services;
    }
    return services
        .where((service) => service.categoryId == selectedCategoryId)
        .toList();
  }

  HomeState copyWith({
    HomeStatus? status,
    List<HomeCategory>? categories,
    String? selectedCategoryId,
    bool overrideSelectedCategory = false,
    HomePackage? featuredPackage,
    List<HomePackage>? packages,
    List<Service>? services,
    int? bottomNavIndex,
    String? errorMessage,
    UserPackage? activeUserPackage,
    bool overrideActiveUserPackage = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategoryId: overrideSelectedCategory
          ? selectedCategoryId
          : (selectedCategoryId ?? this.selectedCategoryId),
      featuredPackage: featuredPackage ?? this.featuredPackage,
      packages: packages ?? this.packages,
      services: services ?? this.services,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      errorMessage: errorMessage,
      activeUserPackage: overrideActiveUserPackage
          ? activeUserPackage
          : (activeUserPackage ?? this.activeUserPackage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedCategoryId,
        featuredPackage,
        packages,
        services,
        bottomNavIndex,
        errorMessage,
        activeUserPackage,
      ];
}
