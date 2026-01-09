import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/packages/checkout/bloc/bloc.dart';
import 'package:sudz/features/packages/checkout/ui/widgets/widgets.dart';
import 'package:sudz/features/packages/data/models/models.dart';
import 'package:sudz/features/store/shared/ui/widgets/store_payment_tile.dart';
import 'package:sudz/shared/widgets/custom_button.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackageCheckoutPage extends StatelessWidget {
  final Package package;

  const PackageCheckoutPage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PackageCheckoutBloc>()..add(PackageCheckoutStarted(package)),
      child: _PackageCheckoutView(package: package),
    );
  }
}

class _PackageCheckoutView extends StatelessWidget {
  final Package package;

  const _PackageCheckoutView({required this.package});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'packages.checkout.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PackageCheckoutBloc, PackageCheckoutState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess && state.package != null) {
            context.pushReplacementNamed(
              RouteNames.packagesConfirmation,
              extra: state.package,
            );
          } else if (state.status.isFailure && state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'packages.error_generic'.tr(),
                color: theme.colorScheme.error,
                textAlign: TextAlign.center,
              ),
            );
          }

          final checkoutBloc = context.read<PackageCheckoutBloc>();
          final selectedPackage = state.package ?? package;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PackageCheckoutSummaryCard(package: selectedPackage),
                SizedBox(height: 24.h),
                CustomText(
                  'packages.checkout.payment_methods'.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 12.h),
                Column(
                  children: state.paymentMethods
                      .map(
                        (method) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: StorePaymentTile(
                            method: method,
                            isSelected: method.id == state.selectedMethodId,
                            onTap: () => checkoutBloc.add(
                              PackageCheckoutPaymentSelected(method.id),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16.h),
                PackageCheckoutTotals(
                  subtotal: state.subtotal,
                  total: state.total,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'packages.checkout.confirm_cta'.tr(),
                    onPressed: state.status.isProcessing
                        ? null
                        : () => checkoutBloc.add(
                            const PackageCheckoutSubmitted(),
                          ),
                    isLoading: state.status.isProcessing,
                    height: 48,
                    borderRadius: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
