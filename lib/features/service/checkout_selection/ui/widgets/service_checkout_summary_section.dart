import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import 'package:sudz/features/car/models/service_car.dart';
import 'package:sudz/features/service/models/models.dart';
import 'package:sudz/features/service/schedule/models/models.dart';

class ServiceCheckoutSummarySection extends StatelessWidget {
  final ServiceType serviceType;
  final ServiceCar? car;
  final ServiceScheduleSelection? schedule;
  final String? serviceHelper;

  const ServiceCheckoutSummarySection({
    required this.serviceType,
    this.car,
    this.schedule,
    this.serviceHelper,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'service.checkout.summary_title'.tr(),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          SizedBox(height: 16.h),
          _SummaryTile(
            label: 'service.checkout.summary_service_label'.tr(),
            value: serviceType.title,
            helper:
                serviceHelper ?? '${serviceType.price} ${serviceType.currency}',
          ),
          if (car != null) ...[
            SizedBox(height: 12.h),
            _SummaryTile(
              label: 'service.checkout.summary_car_label'.tr(),
              value: car!.displayName,
              helper: car!.plateNumber,
            ),
          ],
          if (schedule != null) ...[
            SizedBox(height: 12.h),
            _SummaryTile(
              label: 'service.checkout.summary_schedule_label'.tr(),
              value:
                  '${schedule!.day.dayLabel.tr()} ${schedule!.day.dayNumber}',
              helper: schedule!.slot.displayLabel,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final String? helper;

  const _SummaryTile({required this.label, required this.value, this.helper});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(height: 4.h),
        CustomText(
          value,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        if (helper != null) ...[
          SizedBox(height: 2.h),
          CustomText(
            helper!,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ],
    );
  }
}
