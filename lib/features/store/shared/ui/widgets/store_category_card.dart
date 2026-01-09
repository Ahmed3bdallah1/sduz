import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class StoreCategoryCard extends StatelessWidget {
  final StoreCategory category;
  final VoidCallback onTap;

  const StoreCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60.w,
              width: 60.w,
              decoration: BoxDecoration(
                color: category.iconBackground,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Icon(
                category.icon,
                size: 28.sp,
                color: const Color(0xFF2252C7),
              ),
            ),
            SizedBox(height: 12.h),
            CustomTextBody(
              category.nameKey.tr(),
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
