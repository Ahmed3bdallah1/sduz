import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import 'package:sudz/features/service/checkout_selection/bloc/bloc.dart';
import 'package:sudz/features/service/checkout_selection/models/models.dart';
import 'package:sudz/features/service/checkout_selection/ui/widgets/widgets.dart';

class ServiceCheckoutSelectionPage extends StatelessWidget {
  final ServiceCheckoutSelectionParams params;

  const ServiceCheckoutSelectionPage({required this.params, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ServiceCheckoutSelectionBloc>(param1: params),
      child: const ServiceCheckoutSelectionView(),
    );
  }
}

class ServiceCheckoutSelectionView extends StatelessWidget {
  const ServiceCheckoutSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'service.checkout.title'.tr(),
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color:
              theme.appBarTheme.titleTextStyle?.color ??
              theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ServiceCheckoutSelectionBloc, ServiceCheckoutSelectionState>(
        listenWhen: (previous, current) =>
            previous.nextStep != current.nextStep ||
            previous.errorMessage != current.errorMessage ||
            previous.showValidationError != current.showValidationError,
        listener: (context, state) {
          if (state.showValidationError && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: CustomTextBody(
                    state.errorMessage!.tr(),
                    color: theme.colorScheme.onPrimary,
                  ),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
          }

          final nextStep = state.nextStep;
          if (nextStep == null) return;

          final routeName = nextStep == ServiceCheckoutNextStep.package
              ? RouteNames.serviceCheckoutPackage
              : RouteNames.serviceCheckoutSingle;

          final extra = nextStep == ServiceCheckoutNextStep.package
              ? state.package
              : state.serviceType;

          final schedule = state.schedule;

              final queryParameters = schedule == null
                  ? <String, String>{}
                  : {
                      'scheduleDay': schedule.day.date.toIso8601String(),
                      'scheduleSlot': schedule.slot.displayLabel,
                    };

              context.pushNamed(
                routeName,
                extra: extra,
                queryParameters: queryParameters,
              );

          context.read<ServiceCheckoutSelectionBloc>().add(
            const ServiceCheckoutNavigationHandled(),
          );
        },
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceCheckoutSummarySection(
                  serviceType: state.serviceType,
                  car: state.car,
                  schedule: state.schedule,
                  serviceHelper: state.hasAvailablePackage
                      ? 'service.schedule.package_covered'.tr()
                      : '${state.serviceType.price} ${state.serviceType.currency}',
                ),
                SizedBox(height: 20.h),
                ServicePackageAvailabilityInfo(
                  package: state.package,
                  isAvailable: state.hasAvailablePackage,
                  disabledHint: state.hasAvailablePackage
                      ? null
                      : (state.package != null
                            ? 'service.checkout.package_disabled_hint'.tr()
                            : null),
                ),
                SizedBox(height: 24.h),
                CustomText(
                  'service.checkout.selection_title'.tr(),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                SizedBox(height: 16.h),
                ServiceCheckoutOptionCard(
                  title: 'service.checkout.option_single_title'.tr(),
                  subtitle: 'service.checkout.option_single_subtitle'.tr(),
                  isSelected:
                      state.selectedOption ==
                      ServiceCheckoutOption.singleService,
                  isEnabled: true,
                  onTap: () => context.read<ServiceCheckoutSelectionBloc>().add(
                    const ServiceCheckoutOptionChanged(
                      ServiceCheckoutOption.singleService,
                    ),
                  ),
                  trailing: _PriceChip(
                    text:
                        '${state.serviceType.price} ${state.serviceType.currency}',
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.12,
                    ),
                    textColor: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16.h),
                ServiceCheckoutOptionCard(
                  title: 'service.checkout.option_package_title'.tr(),
                  subtitle: state.hasAvailablePackage
                      ? 'service.checkout.option_package_subtitle'.tr()
                      : 'service.checkout.option_package_disabled'.tr(),
                  isSelected:
                      state.selectedOption == ServiceCheckoutOption.package,
                  isEnabled: state.hasAvailablePackage,
                  onTap: () => context.read<ServiceCheckoutSelectionBloc>().add(
                    const ServiceCheckoutOptionChanged(
                      ServiceCheckoutOption.package,
                    ),
                  ),
                  trailing: Icon(
                    Icons.card_giftcard,
                    color: theme.colorScheme.secondary,
                    size: 28.w,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar:
      //     BlocBuilder<
      //       ServiceCheckoutSelectionBloc,
      //       ServiceCheckoutSelectionState
      //     >(
      //       buildWhen: (previous, current) =>
      //           previous.selectedOption != current.selectedOption ||
      //           previous.hasAvailablePackage != current.hasAvailablePackage,
      //       builder: (context, state) {
      //         final buttonLabel = 'service.checkout.button_continue'.tr();
      //         final summaryLabel = 'service.checkout.summary_total_label'.tr();

      //         String summaryValue;
      //         String? helper;

      //         switch (state.selectedOption) {
      //           case ServiceCheckoutOption.package:
      //             summaryValue = 'service.checkout.package_summary_covered'
      //                 .tr();
      //             helper = 'service.checkout.package_summary_helper'.tr();
      //             break;
      //           case ServiceCheckoutOption.singleService:
      //             summaryValue =
      //                 '${state.serviceType.price} ${state.serviceType.currency}';
      //             helper = 'service.checkout.single_summary_helper'.tr();
      //             break;
      //           default:
      //             summaryValue = '--';
      //             helper = null;
      //         }

      //         return ServiceCheckoutSelectionActionBar(
      //           onContinue: () => context
      //               .read<ServiceCheckoutSelectionBloc>()
      //               .add(const ServiceCheckoutContinuePressed()),
      //           isEnabled: state.canSubmit,
      //           isLoading: false,
      //           summaryLabel: summaryLabel,
      //           summaryValue: summaryValue,
      //           buttonLabel: buttonLabel,
      //           helperMessage: helper,
      //         );
      //       },
      //     ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _PriceChip({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: CustomText(
        text,
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }
}
