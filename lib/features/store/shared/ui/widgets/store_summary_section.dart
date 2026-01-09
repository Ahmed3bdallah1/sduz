import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class StoreSummarySection extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const StoreSummarySection({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget row(String label, double value, {bool isTotal = false}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            CustomTextBody(
              label,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: theme.colorScheme.onSurface
                  .withValues(alpha: isTotal ? 0.9 : 0.7),
            ),
            const Spacer(),
            CustomText(
              'store.currency_value'
                  .tr(namedArgs: {'value': value.toStringAsFixed(1)}),
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          row('store.summary.subtotal'.tr(), subtotal),
          row('store.summary.delivery'.tr(), deliveryFee),
          const Divider(height: 24),
          row('store.summary.total'.tr(), total, isTotal: true),
        ],
      ),
    );
  }
}
