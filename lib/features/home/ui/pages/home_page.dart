import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/address/bloc/address_bloc.dart';
import 'package:sudz/features/address/bloc/address_event.dart';
import 'package:sudz/features/home/bloc/bloc.dart';
import 'package:sudz/features/home/ui/widgets/widgets.dart';
import 'package:sudz/features/home/ui/widgets/home_service_list.dart';
import 'package:sudz/features/orders/bloc/bloc.dart';
import 'package:sudz/features/orders/ui/widgets/widgets.dart';
import 'package:sudz/features/profile/home/bloc/bloc.dart';
import 'package:sudz/features/profile/home/ui/pages/profile_home_page.dart';
import 'package:sudz/features/store/home/bloc/bloc.dart';
import 'package:sudz/features/store/shared/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<AddressBloc>()..add(const AddressRequested()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.bottomNavIndex != curr.bottomNavIndex,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: state.bottomNavIndex == 0 ? const HomeAppBar() : null,
          body: IndexedStack(
            index: state.bottomNavIndex,
            children: const [
              _HomeContentContainer(),
              _OrdersTab(),
              _StoreTab(),
              _ProfileTab(),
            ],
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: state.bottomNavIndex,
            onItemSelected: (index) {
              context.read<HomeBloc>().add(HomeBottomNavChanged(index));
            },
          ),
        );
      },
    );
  }
}

class _HomeContentContainer extends StatelessWidget {
  const _HomeContentContainer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) => prev != curr,
      builder: (context, state) {
        return _HomeContent(state: state);
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeState state;

  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.status == HomeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == HomeStatus.failure) {
      return Center(
        child: CustomTextBody(
          state.errorMessage ?? 'حدث خطأ غير متوقع',
          color: theme.colorScheme.error,
        ),
      );
    }

    final packages = state.packages;
    final featured = state.featuredPackage;
    final otherPackages = featured == null
        ? packages
        : packages.where((pkg) => pkg.id != featured.id).toList();

    // Show at least 2 packages if they exist
    final displayPackages = otherPackages.take(2).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (featured != null) ...[
          //   HomeFeaturedBanner(package: featured),
          //   SizedBox(height: 24.h),
          // ],
          HomeFeaturedBanner(),
          SizedBox(height: 24.h),
          if (state.activeUserPackage != null) ...[
            _HomeHighlightsRow(state: state),
            SizedBox(height: 24.h),
          ],
          HomeSectionHeader(title: 'home.services_title'.tr()),
          HomeCategoryList(
            categories: state.categories,
            selectedId: state.selectedCategoryId,
            onSelected: (id) =>
                context.read<HomeBloc>().add(HomeCategorySelected(id)),
          ),
          if (state.filteredServices.isNotEmpty) ...[
            SizedBox(height: 16.h),
            HomeServiceList(services: state.filteredServices),
          ],
          SizedBox(height: 24.h),
          if (displayPackages.isNotEmpty) ...[
            HomeSectionHeader(
              title: 'home.packages_title'.tr(),
              actionLabel: 'home.view_all'.tr(),
              onAction: () {
                context.push(RouteNames.packages);
              },
            ),
            ...displayPackages.map((pkg) {
              print(pkg.imageUrl);
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: HomePackageCard(package: pkg),
              );
            }),
          ],
          SizedBox(height: 16.h),
          // HomeSectionHeader(title: 'الأكثر مبيعاً'),
          // HomeBestSellerList(packages: packages),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalDatabaseService>(
      future: LocalDatabaseService.instance,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final localDb = snapshot.data!;
        final token = localDb.getToken();

        if (token == null || token.isEmpty) {
          return _OrdersLoginRequired();
        }

        return BlocProvider(
          create: (_) => getIt<OrdersBloc>()..add(const OrdersStarted()),
          child: BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              final theme = Theme.of(context);

              if (state.status.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status.isFailure) {
                return Center(
                  child: CustomTextBody(
                    state.errorMessage ?? 'store.error_generic'.tr(),
                    color: theme.colorScheme.error,
                  ),
                );
              }

              final bloc = context.read<OrdersBloc>();
              final orders = state.currentOrders;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h),
                    OrdersSegmentedControl(
                      selectedSegment: state.segment,
                      onSegmentChanged: (segment) =>
                          bloc.add(OrdersSegmentChanged(segment)),
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          return OrdersBookingCard(booking: orders[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _OrdersLoginRequired extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80.sp,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            SizedBox(height: 24.h),
            CustomText(
              'common.login_required_title'.tr(),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomTextBody(
              'common.login_required_message'.tr(),
              textAlign: TextAlign.center,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              text: 'common.login_button'.tr(),
              onPressed: () {
                context.push(RouteNames.login);
              },
              backgroundColor: AppTheme.primaryLight,
              textColor: Colors.white,
              height: 48,
              borderRadius: 12,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreTab extends StatelessWidget {
  const _StoreTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoreHomeBloc>()..add(const StoreHomeStarted()),
      child: BlocBuilder<StoreHomeBloc, StoreHomeState>(
        builder: (context, state) {
          final theme = Theme.of(context);

          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'store.error_generic'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          final categories = state.categories;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return StoreCategoryCard(
                  category: category,
                  onTap: () {
                    context.pushNamed(
                      RouteNames.storeCategory,
                      extra: category,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileHomeBloc>()..add(const ProfileHomeStarted()),
      child: const ProfileHomeBody(),
    );
  }
}

class _HomeHighlightsRow extends StatelessWidget {
  final HomeState state;

  const _HomeHighlightsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = state.activeUserPackage;
    if (active == null) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    final remainingDays = (active.expiryDate.difference(now).inDays).clamp(
      0,
      999,
    );

    final washesRemaining = active.washesRemaining;

    return Container(
      width: MediaQuery.sizeOf(context).width,

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.03),
            blurRadius: 5.sp,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          children: [
            Row(
              children: [
                CustomText('home.package_name'.tr(), fontSize: 12.sp),
                const Spacer(),
                CustomText(active.packageTitle, fontSize: 13.sp),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                CustomText(
                  'home.remaining_days'.tr(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w200,
                ),
                const Spacer(),
                CustomText(
                  '$remainingDays ${'home.day'.tr()}',
                  fontSize: 13.sp,
                  color: AppTheme.primaryLight,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                CustomText(
                  'home.remaining_washes'.tr(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w200,
                ),
                const Spacer(),
                CustomText(
                  '$washesRemaining ${'home.wash'.tr()}',
                  fontSize: 13.sp,
                  color: AppTheme.primaryLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // final totalOrders = state.packages.fold<int>(
    //   0,
    //   (previousValue, element) => previousValue + element.ordersCount,
    // );
    // final avgDuration = state.packages.isNotEmpty
    //     ? state.packages.map((e) => e.durationMinutes).reduce((a, b) => a + b) /
    //           state.packages.length
    //     : 0;

    // final highlights = [
    //   _HighlightItem(
    //     icon: Icons.shopping_bag_outlined,
    //     label: 'إجمالي الطلبات',
    //     value: '$totalOrders',
    //     badgeColor: theme.colorScheme.primary.withValues(alpha: 0.12),
    //     iconColor: theme.colorScheme.primary,
    //   ),
    //   _HighlightItem(
    //     icon: Icons.miscellaneous_services_outlined,
    //     label: 'الخدمات المتاحة',
    //     value: '${state.categories.length}',
    //     badgeColor: AppTheme.accent.withValues(alpha: 0.12),
    //     iconColor: AppTheme.accent,
    //   ),
    //   _HighlightItem(
    //     icon: Icons.access_time,
    //     label: 'متوسط المدة',
    //     value: '${avgDuration.round()} دقيقة',
    //     badgeColor: theme.colorScheme.secondary.withValues(alpha: 0.12),
    //     iconColor: theme.colorScheme.secondary,
    //   ),
    // ];

    // final items = <Widget>[];
    // for (var i = 0; i < highlights.length; i++) {
    //   items.add(
    //     Expanded(
    //       child: Padding(
    //         padding: EdgeInsetsDirectional.only(
    //           end: i == highlights.length - 1 ? 0 : 12.w,
    //         ),
    //         child: highlights[i],
    //       ),
    //     ),
    //   );
    // }

    // return Row(children: items);
  }
}
