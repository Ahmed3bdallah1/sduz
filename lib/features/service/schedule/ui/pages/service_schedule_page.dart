import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/address/domain/entities/user_address.dart';
import 'package:sudz/features/address/ui/widgets/address_picker_bottom_sheet.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import '../../bloc/bloc.dart';
import '../../models/models.dart';
import '../widgets/widgets.dart';

class ServiceSchedulePage extends StatelessWidget {
  final ServiceScheduleParams params;

  const ServiceSchedulePage({required this.params, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ServiceScheduleBloc>()..add(const ServiceScheduleStarted()),
      child: ServiceScheduleView(params: params),
    );
  }
}

class ServiceScheduleView extends StatelessWidget {
  final ServiceScheduleParams params;

  const ServiceScheduleView({required this.params, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'service.schedule.title'.tr(),
          fontSize: 15.sp,
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
      body: BlocConsumer<ServiceScheduleBloc, ServiceScheduleState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.navigateNext != current.navigateNext,
        listener: (context, state) {
          if (state.errorMessage != null) {
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

          if (state.navigateNext) {
            final selection =
                state.selectedSlot == null || state.selectedDay == null
                ? null
                : ServiceScheduleSelection(
                    day: state.selectedDay!,
                    slot: state.selectedSlot!,
                  );

            if (selection != null) {
              _navigateToCheckout(context, params, selection);
            }

            context.read<ServiceScheduleBloc>().add(
              const ServiceScheduleNavigationHandled(),
            );
          }
        },
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final bloc = context.read<ServiceScheduleBloc>();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                // Service Image Carousel
                ServiceImageCarousel(
                  images: const [
                    'assets/images/profile.png',
                    'assets/images/profile.png',
                    'assets/images/profile.png',
                  ],
                ),
                SizedBox(height: 24.h),

                // Description Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ServiceDescriptionSection(
                    description:
                        'خدمة الغسيل الشامل للسيارات تتضمن التنظيف الداخلي والخارجي باستخدام أحدث المعدات والمواد عالية الجودة. نحن نهتم بكل التفاصيل لضمان حصولك على سيارة نظيفة ولامعة. تشمل الخدمة غسيل الهيكل الخارجي، تنظيف الإطارات، تلميع الزجاج، وتنظيف المقاعد والأرضيات الداخلية.',
                  ),
                ),
                SizedBox(height: 20.h),

                // Service Options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ServiceOptionsSection(
                    options: const [
                      ServiceOption(
                        id: 'fragrance',
                        title: 'معطر',
                        price: '(+10 ريال)',
                      ),
                      ServiceOption(
                        id: 'additional',
                        title: 'إضافة',
                        price: '(+10 ريال)',
                      ),
                    ],
                    selectedOptionId: null,
                    onOptionSelected: (id) {
                      // Handle option selection
                    },
                  ),
                ),
                SizedBox(height: 24.h),

                // Date Selector
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ServiceScheduleDateSelector(
                    days: state.days,
                    selectedIndex: state.selectedDayIndex,
                    onDaySelected: (index) =>
                        bloc.add(ServiceScheduleDayChanged(index)),
                    onPrevious: () {
                      final prev = state.selectedDayIndex - 1;
                      if (prev >= 0) {
                        bloc.add(ServiceScheduleDayChanged(prev));
                      }
                    },
                    onNext: () {
                      final next = state.selectedDayIndex + 1;
                      if (next < state.days.length) {
                        bloc.add(ServiceScheduleDayChanged(next));
                      }
                    },
                  ),
                ),
                SizedBox(height: 16.h),

                // Time Slots
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ServiceScheduleTimeSlots(
                    day: state.selectedDay,
                    selectedSlotId: state.selectedSlotId,
                    onSlotSelected: (slotId) =>
                        bloc.add(ServiceScheduleSlotSelected(slotId)),
                  ),
                ),
                SizedBox(height: 24.h),

                // Request Alternate Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 20.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'service.schedule.no_alternate_message'.tr(),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                        SizedBox(width: 12.w),
                        TextButton(
                          onPressed: () => bloc.add(
                            const ServiceScheduleAlternateRequested(),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: Color(0xffABC2E3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: CustomText(
                            'service.schedule.request_alternate'.tr(),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffABC2E3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.alternateRequested) ...[
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomTextBody(
                      'service.schedule.alternate_requested'.tr(),
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ServiceScheduleBloc, ServiceScheduleState>(
            buildWhen: (previous, current) =>
                previous.selectedSlotId != current.selectedSlotId,
            builder: (context, state) {
              final priceLabel = 'service.schedule.total_label'.tr();
              final priceValue = params.hasActivePackage
                  ? 'service.schedule.package_covered'.tr()
                  : '${params.serviceType.price} ${params.serviceType.currency}';

              return ServiceScheduleActionBar(
                day: state.selectedDay,
                slot: state.selectedSlot,
                onContinue: () => context.read<ServiceScheduleBloc>().add(
                  const ServiceScheduleContinuePressed(),
                ),
                isEnabled: state.canContinue,
                priceLabel: priceLabel,
                priceValue: priceValue,
              );
            },
          ),
    );
  }

  Future<void> _navigateToCheckout(
    BuildContext context,
    ServiceScheduleParams params,
    ServiceScheduleSelection selection,
  ) async {
    // Show address picker bottom sheet to select address
    final selectedAddress = await showModalBottomSheet<UserAddress>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddressPickerBottomSheet(),
    );

    if (selectedAddress == null || !context.mounted) {
      return;
    }

    // Navigate to checkout single page with all required data
    context.pushNamed(
      RouteNames.serviceCheckoutSingle,
      extra: {
        'serviceType': params.serviceType,
        'car': params.car,
        'address': selectedAddress,
        'scheduleSelection': selection,
        'activePackage': params.activePackage,
      },
    );
  }
}
