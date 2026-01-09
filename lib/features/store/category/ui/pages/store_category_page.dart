import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/store/category/bloc/bloc.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/features/store/shared/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class StoreCategoryPage extends StatelessWidget {
  final StoreCategory category;

  const StoreCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StoreCategoryBloc>()..add(StoreCategoryStarted(category.id)),
      child: _StoreCategoryView(category: category),
    );
  }
}

class _StoreCategoryView extends StatelessWidget {
  final StoreCategory category;

  const _StoreCategoryView({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          category.nameKey.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.storeCart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: BlocBuilder<StoreCategoryBloc, StoreCategoryState>(
        builder: (context, state) {
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

          final bloc = context.read<StoreCategoryBloc>();
          final filters = state.filters;
          final products = state.products;

          return CustomScrollView(
            slivers: [
              // Fixed Filters at the top
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Row(
                          children: filters.map((filter) {
                            final isSelected =
                                filter.id == state.selectedFilterId;
                            return Padding(
                              padding: EdgeInsetsDirectional.only(start: 8.w),
                              child: StoreFilterChip(
                                label: filter.labelKey.tr(),
                                isSelected: isSelected,
                                onTap: () => bloc.add(
                                  StoreCategoryFilterChanged(filter.id),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      StoreSortDropdown(value: 'suggested', onChanged: (_) {}),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              // Scrollable Grid
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = products[index];
                    return StoreProductCard(
                      product: product,
                      onTap: () => context.pushNamed(
                        RouteNames.storeProduct,
                        extra: product,
                      ),
                      onAddToCart: () =>
                          context.pushNamed(RouteNames.storeCart),
                    );
                  }, childCount: products.length),
                ),
              ),
              // Load More Button
              if (state.hasMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: TextButton(
                        onPressed: () =>
                            bloc.add(const StoreCategoryLoadMoreRequested()),
                        child: CustomText(
                          'store.action.show_more'.tr(),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
