import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/packages/all_packages/bloc/bloc.dart';
import 'package:sudz/features/packages/all_packages/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PackagesBloc>()..add(const PackagesStarted()),
      child: const _PackagesView(),
    );
  }
}

class _PackagesView extends StatelessWidget {
  const _PackagesView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'packages.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PackagesBloc, PackagesState>(
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
                'packages.error_generic'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          if (state.packages.isEmpty) {
            return Center(
              child: CustomTextBody(
                'packages.empty_state'.tr(),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            );
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ).copyWith(top: 16.h, bottom: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'packages.choose_title'.tr(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 6.h),
                      CustomTextBody(
                        'packages.choose_subtitle'.tr(),
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: 24.h,
                    ),
                    itemBuilder: (context, index) {
                      final package = state.packages[index];
                      final isSelected = state.selectedPackageId == package.id;

                      return PackageCard(
                        package: package,
                        isSelected: isSelected,
                        onTap: () => context.read<PackagesBloc>().add(
                          PackageSelectionChanged(package.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemCount: state.packages.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<PackagesBloc, PackagesState>(
        builder: (context, state) {
          if (!state.status.isSuccess || state.packages.isEmpty) {
            return const SizedBox.shrink();
          }

          return PackageSummaryBar(
            total: state.totalPrice,
            isEnabled: state.selectedPackage != null,
            onCheckout: () {
              final selected = state.selectedPackage;
              if (selected == null) return;
              context.pushNamed(RouteNames.packagesCheckout, extra: selected);
            },
          );
        },
      ),
    );
  }
}
