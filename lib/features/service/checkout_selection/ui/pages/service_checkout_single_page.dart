import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import '../../../../address/domain/entities/user_address.dart';
import '../../../../car/models/service_car.dart';
import '../../../models/models.dart';
import '../../../schedule/models/models.dart';
import '../../bloc/bloc.dart';

class ServiceCheckoutSinglePage extends StatelessWidget {
  const ServiceCheckoutSinglePage({
    required this.serviceType,
    required this.car,
    required this.address,
    required this.scheduleSelection,
    this.activePackage,
    super.key,
  });

  final ServiceType serviceType;
  final ServiceCar car;
  final UserAddress address;
  final ServiceScheduleSelection scheduleSelection;
  final ServicePackage? activePackage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<
          ServiceCheckoutBloc Function({
            required ServiceType serviceType,
            required ServiceCar car,
            required UserAddress address,
            required ServiceScheduleSelection scheduleSelection,
            ServicePackage? activePackage,
          })>()(
        serviceType: serviceType,
        car: car,
        address: address,
        scheduleSelection: scheduleSelection,
        activePackage: activePackage,
      ),
      child: const ServiceCheckoutSingleView(),
    );
  }
}

class ServiceCheckoutSingleView extends StatelessWidget {
  const ServiceCheckoutSingleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'service.checkout.single_title'.tr(),
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
      body: BlocConsumer<ServiceCheckoutBloc, ServiceCheckoutState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: CustomTextBody(
                    'service.checkout.success_message'.tr(),
                    color: theme.colorScheme.onPrimary,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            // Navigate back to home or orders page
            context.pop();
          }

          if (state.errorMessage != null && state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: CustomTextBody(
                    state.errorMessage!,
                    color: theme.colorScheme.onError,
                  ),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status.isProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Summary Section
                _buildSectionTitle(context, 'service.checkout.summary'.tr()),
                SizedBox(height: 12.h),
                _buildSummaryCard(context, state),
                SizedBox(height: 24.h),

                // Schedule Summary Section
                _buildSectionTitle(context, 'service.checkout.schedule'.tr()),
                SizedBox(height: 12.h),
                _buildScheduleCard(context, state),
                SizedBox(height: 24.h),

                // Car Info Section
                _buildSectionTitle(context, 'service.checkout.car'.tr()),
                SizedBox(height: 12.h),
                _buildCarCard(context, state),
                SizedBox(height: 24.h),

                // Address Section
                _buildSectionTitle(context, 'service.checkout.address'.tr()),
                SizedBox(height: 12.h),
                _buildAddressCard(context, state),
                SizedBox(height: 24.h),

                // Payment Method Section
                _buildSectionTitle(
                    context, 'service.checkout.payment_method'.tr()),
                SizedBox(height: 12.h),
                _buildPaymentMethodSelector(context, state),
                SizedBox(height: 24.h),

                // Notes Section
                _buildSectionTitle(context, 'service.checkout.notes'.tr()),
                SizedBox(height: 12.h),
                _buildNotesField(context),
                SizedBox(height: 32.h),

                // Total Amount
                _buildTotalAmount(context, state),
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<ServiceCheckoutBloc, ServiceCheckoutState>(
        buildWhen: (previous, current) =>
            previous.canSubmit != current.canSubmit ||
            previous.status != current.status,
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: state.canSubmit
                      ? () => context
                          .read<ServiceCheckoutBloc>()
                          .add(const ServiceCheckoutSubmitted())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    disabledBackgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: state.status.isProcessing
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : CustomText(
                          'service.checkout.confirm_booking'.tr(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimary,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return CustomText(
      title,
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
  }

  Widget _buildSummaryCard(BuildContext context, ServiceCheckoutState state) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            state.serviceType.title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          SizedBox(height: 8.h),
          CustomText(
            state.serviceType.subtitle,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
      BuildContext context, ServiceCheckoutState state) {
    final theme = Theme.of(context);
    final day = state.scheduleSelection.day;
    final slot = state.scheduleSelection.slot;
    final formatter = DateFormat('EEEE, MMM d, yyyy');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: theme.colorScheme.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  formatter.format(day.date),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  slot.displayLabel,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, ServiceCheckoutState state) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_car,
            color: theme.colorScheme.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  state.car.displayName,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  '${state.car.colorName} • ${state.car.plateNumber}',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, ServiceCheckoutState state) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            color: theme.colorScheme.primary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  state.address.title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  state.address.shortDescription,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector(
      BuildContext context, ServiceCheckoutState state) {
    final theme = Theme.of(context);
    final bloc = context.read<ServiceCheckoutBloc>();

    return Column(
      children: [
        _buildPaymentMethodOption(
          context,
          theme,
          'cod',
          'service.checkout.payment_cod'.tr(),
          Icons.money,
          state.selectedPaymentMethod == 'cod',
          () => bloc.add(const ServiceCheckoutPaymentMethodChanged('cod')),
        ),
        SizedBox(height: 12.h),
        _buildPaymentMethodOption(
          context,
          theme,
          'card',
          'service.checkout.payment_card'.tr(),
          Icons.credit_card,
          state.selectedPaymentMethod == 'card',
          () => bloc.add(const ServiceCheckoutPaymentMethodChanged('card')),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(
    BuildContext context,
    ThemeData theme,
    String value,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<ServiceCheckoutBloc>();

    return TextField(
      maxLines: 3,
      onChanged: (value) => bloc.add(ServiceCheckoutNotesChanged(value)),
      decoration: InputDecoration(
        hintText: 'service.checkout.notes_hint'.tr(),
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmount(BuildContext context, ServiceCheckoutState state) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            'service.checkout.total'.tr(),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          CustomText(
            state.hasActivePackage
                ? 'service.checkout.covered_by_package'.tr()
                : '${state.totalAmount.toStringAsFixed(2)} ${state.serviceType.currency}',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
