import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/store/checkout/bloc/bloc.dart';
import 'package:sudz/features/store/shared/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class StoreCheckoutPage extends StatelessWidget {
  final double total;

  const StoreCheckoutPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StoreCheckoutBloc>()..add(StoreCheckoutStarted(total: total)),
      child: const _StoreCheckoutView(),
    );
  }
}

class _StoreCheckoutView extends StatelessWidget {
  const _StoreCheckoutView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'store.checkout.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<StoreCheckoutBloc, StoreCheckoutState>(
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

          final bloc = context.read<StoreCheckoutBloc>();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  tileColor: Colors.white,

                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    // vertical: 12.h,
                  ),
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: theme.colorScheme.secondary,
                  ),
                  title: CustomText(
                    'store.checkout.address_title'.tr(),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: CustomTextBody(
                    state.addressKey.tr(),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: CustomText(
                      'store.action.edit'.tr(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                CustomText(
                  'store.checkout.payment_method'.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 12.h),
                Column(
                  children: state.paymentMethods.map((method) {
                    final isSelected = method.id == state.selectedMethodId;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: StorePaymentTile(
                        method: method,
                        isSelected: isSelected,
                        onTap: () =>
                            bloc.add(StoreCheckoutPaymentSelected(method.id)),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.h),
                StoreSummarySection(
                  subtotal: state.subtotal,
                  deliveryFee: state.deliveryFee,
                  total: state.total,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'store.checkout.buy'.tr(),
                  onPressed: () => context.pushReplacementNamed(
                    RouteNames.storeOrderConfirmation,
                  ),
                  height: 48.h,
                  fontSize: 13.sp,
                  width: double.infinity,
                  borderRadius: 16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
