import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/store/product/bloc/bloc.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/features/store/shared/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class StoreProductPage extends StatelessWidget {
  final StoreProduct product;

  const StoreProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StoreProductBloc>()..add(StoreProductStarted(product.id)),
      child: _StoreProductView(product: product),
    );
  }
}

class _StoreProductView extends StatelessWidget {
  final StoreProduct product;

  const _StoreProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          product.nameKey.tr(),
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
      body: BlocBuilder<StoreProductBloc, StoreProductState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure || state.product == null) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'store.error_generic'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          final current = state.product!;
          final related = state.relatedProducts;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                  ),
                  child: Image.network(
                    'https://m.media-amazon.com/images/I/412cGL-qePL._SR290,290_.jpg',
                    fit: BoxFit.contain,
                    height: 220.h,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220.h,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    CustomText(
                      'store.product.type'.tr(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const Spacer(),
                    if (current.oldPrice != null)
                      CustomText(
                        'store.currency_value'.tr(
                          namedArgs: {
                            'value': current.oldPrice!.toStringAsFixed(1),
                          },
                        ),
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                        decoration: TextDecoration.lineThrough,
                      ),
                    SizedBox(width: 8.w),
                    CustomText(
                      'store.currency_value'.tr(
                        namedArgs: {'value': current.price.toStringAsFixed(1)},
                      ),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomText(
                  'store.product.details'.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                CustomTextBody(
                  current.descriptionKey.tr(),
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 12.h),
                CustomTextBody(
                  'store.product.origin'.tr(
                    namedArgs: {'country': 'store.product.saudi'.tr()},
                  ),
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'store.action.add_to_cart'.tr(),
                  onPressed: () => context.pushNamed(RouteNames.storeCart),
                  height: 48.h,
                  fontSize: 13.sp,
                  width: double.infinity,
                  borderRadius: 16,
                ),
                if (related.isNotEmpty) ...[
                  SizedBox(height: 32.h),
                  CustomText(
                    'store.product.related'.tr(),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 240.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: related.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16.w),
                      itemBuilder: (context, index) {
                        final item = related[index];
                        return SizedBox(
                          width: 180.w,
                          child: StoreProductCard(
                            product: item,
                            onTap: () => context.pushReplacementNamed(
                              RouteNames.storeProduct,
                              extra: item,
                            ),
                            onAddToCart: () =>
                                context.pushNamed(RouteNames.storeCart),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
