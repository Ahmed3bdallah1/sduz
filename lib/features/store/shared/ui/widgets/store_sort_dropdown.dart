import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class StoreSortDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const StoreSortDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: [
            DropdownMenuItem(
              value: 'suggested',
              child: CustomText(
                'store.sort.suggested'.tr(),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            DropdownMenuItem(
              value: 'price_low',
              child: CustomText(
                'store.sort.price_low'.tr(),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            DropdownMenuItem(
              value: 'price_high',
              child: CustomText(
                'store.sort.price_high'.tr(),
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
