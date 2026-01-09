import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/profile/my_packages/bloc/my_packages_bloc.dart';
import 'package:sudz/features/profile/my_packages/bloc/my_packages_event.dart';
import 'package:sudz/features/profile/my_packages/bloc/my_packages_state.dart';
import 'package:sudz/features/profile/my_packages/ui/widgets/my_package_card.dart';
import 'package:sudz/shared/widgets/custom_button.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class MyPackagesPage extends StatelessWidget {
  const MyPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyPackagesBloc>()..add(const MyPackagesStarted()),
      child: const _MyPackagesView(),
    );
  }
}

class _MyPackagesView extends StatelessWidget {
  const _MyPackagesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'profile.packages.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<MyPackagesBloc, MyPackagesState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'profile.error_generic'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          if (state.packages.isEmpty) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard_outlined,
                      size: 64.sp,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      'profile.packages.empty_state.title'.tr(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextBody(
                      'profile.packages.empty_state.subtitle'.tr(),
                      textAlign: TextAlign.center,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 30.h),
                    CustomPrimaryButton(
                      text: 'profile.packages.add_button'.tr(),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.packages.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final pkg = state.packages[index];
                        final isSelected = state.selectedPackageId == pkg.id;
                        return MyPackageCard(
                          package: pkg,
                          isSelected: isSelected,
                          onTap: () => context.read<MyPackagesBloc>().add(
                            MyPackageSelected(pkg.id),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomPrimaryButton(
                    text: 'profile.packages.add_button'.tr(),
                    onPressed: () {
                      context.push(RouteNames.packages);
                    },
                    height: 40.h,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
