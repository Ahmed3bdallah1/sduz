import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import '../../models/models.dart';

class ServiceScheduleActionBar extends StatelessWidget {
  final ServiceScheduleDay? day;
  final ServiceTimeSlot? slot;
  final VoidCallback onContinue;
  final bool isEnabled;
  final String priceLabel;
  final String priceValue;

  const ServiceScheduleActionBar({
    required this.day,
    required this.slot,
    required this.onContinue,
    required this.isEnabled,
    required this.priceLabel,
    required this.priceValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final stepLabel = slot == null ? '' : '2 | ${'ميعاد تم تحديده'}';

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (slot != null)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: CustomText(
                stepLabel,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: isEnabled ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'service.schedule.continue'.tr(),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  CustomText(
                    priceValue,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
