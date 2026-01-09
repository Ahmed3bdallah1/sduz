import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class StorePaymentTile extends StatelessWidget {
  final StorePaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const StorePaymentTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.secondary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondary
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
          // boxShadow: [
          //   if (isSelected)
          //     BoxShadow(
          //       color: theme.colorScheme.secondary.withValues(alpha: 0.12),
          //       blurRadius: 12,
          //       offset: const Offset(0, 6),
          //     ),
          // ],
        ),
        child: Row(
          children: [
            Icon(
              method.type == StorePaymentType.cash
                  ? Icons.account_balance_wallet_outlined
                  : Icons.credit_card,
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    method.nameKey.tr(),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  if (method.maskedNumber != null) ...[
                    SizedBox(height: 4.h),
                    CustomTextBody(
                      method.maskedNumber!,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
