import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackageCheckoutTotals extends StatelessWidget {
  final double subtotal;
  final double total;

  const PackageCheckoutTotals({
    super.key,
    required this.subtotal,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget row({
      required String label,
      required double value,
      bool isTotal = false,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            CustomTextBody(
              label,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(
                alpha: isTotal ? 0.9 : 0.7,
              ),
            ),
            const Spacer(),
            CustomText(
              'packages.checkout.price_value'.tr(
                namedArgs: {'value': value.toStringAsFixed(0)},
              ),
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          row(label: 'packages.checkout.subtotal_label'.tr(), value: subtotal),
          const Divider(height: 24),
          row(
            label: 'packages.checkout.total_label'.tr(),
            value: total,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
