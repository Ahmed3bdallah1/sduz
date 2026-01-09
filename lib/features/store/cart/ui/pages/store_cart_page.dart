import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/store/cart/bloc/bloc.dart';
import 'package:sudz/features/store/shared/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class StoreCartPage extends StatelessWidget {
  const StoreCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoreCartBloc>()..add(const StoreCartStarted()),
      child: const _StoreCartView(),
    );
  }
}

class _StoreCartView extends StatelessWidget {
  const _StoreCartView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: CustomText(
          'store.cart.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<StoreCartBloc, StoreCartState>(
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

          final bloc = context.read<StoreCartBloc>();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...state.items.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: StoreCartItemTile(
                      item: item,
                      onIncrement: () =>
                          bloc.add(StoreCartItemIncremented(item.product.id)),
                      onDecrement: () =>
                          bloc.add(StoreCartItemDecremented(item.product.id)),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                CustomText(
                  'store.cart.related'.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 220.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.relatedProducts.length,
                    separatorBuilder: (_, __) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      final product = state.relatedProducts[index];
                      return SizedBox(
                        width: 180.w,
                        child: StoreProductCard(
                          product: product,
                          onTap: () => context.pushNamed(
                            RouteNames.storeProduct,
                            extra: product,
                          ),
                          onAddToCart: () {},
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                StoreSummarySection(
                  subtotal: state.subtotal,
                  deliveryFee: state.deliveryFee,
                  total: state.total,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'store.cart.checkout'.tr(),
                  onPressed: () => context.pushNamed(
                    RouteNames.storeCheckout,
                    extra: state.total,
                  ),
                  height: 48.h,
                  borderRadius: 16,
                  fontSize: 13.sp,
                  width: double.infinity,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
