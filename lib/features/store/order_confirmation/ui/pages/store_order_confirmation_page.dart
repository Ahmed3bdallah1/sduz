import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/store/order_confirmation/bloc/bloc.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class StoreOrderConfirmationPage extends StatelessWidget {
  const StoreOrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<StoreOrderConfirmationBloc>()
            ..add(const StoreOrderConfirmationStarted()),
      child: const _StoreOrderConfirmationView(),
    );
  }
}

class _StoreOrderConfirmationView extends StatelessWidget {
  const _StoreOrderConfirmationView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            BlocBuilder<
              StoreOrderConfirmationBloc,
              StoreOrderConfirmationState
            >(
              builder: (context, state) {
                if (state.status.isLoading || state.status.isInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: Image.asset(
                                'assets/icons/11668709_20945732 1.png',
                                height: 200.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 200.h,
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            CustomText(
                              'store.confirmation.title'.tr(),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            CustomTextBody(
                              'store.confirmation.subtitle'.tr(),
                              textAlign: TextAlign.center,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: 'store.confirmation.back_home'.tr(),
                        onPressed: () => context.goNamed(RouteNames.home),
                        height: 48.h,
                        borderRadius: 8.sp,
                        fontSize: 15.sp,
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
