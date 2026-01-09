import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_button.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackageSummaryBar extends StatelessWidget {
  final double total;
  final VoidCallback? onCheckout;
  final bool isEnabled;
  final bool isProcessing;

  const PackageSummaryBar({
    super.key,
    required this.total,
    required this.onCheckout,
    required this.isEnabled,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140.w,
            child: CustomButton(
              text: 'packages.summary.checkout_cta'.tr(),
              onPressed: isEnabled ? onCheckout : null,
              isLoading: isProcessing,
              height: 40.h,
              borderRadius: 8.sp,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextCaption(
                'packages.summary.total_label'.tr(),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(height: 6.h),
              CustomText(
                'packages.summary.total_value'.tr(
                  namedArgs: {'value': total.toStringAsFixed(0)},
                ),
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
