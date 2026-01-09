import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/profile/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class DedicationTypeSheet extends StatelessWidget {
  final List<ProfileDedicationType> types;
  final String? selectedTypeId;

  const DedicationTypeSheet({
    super.key,
    required this.types,
    required this.selectedTypeId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            ...types.map(
              (type) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _TypeButton(
                  label: type.title,
                  isSelected: selectedTypeId == type.id,
                  onPressed: () => Navigator.of(context).pop(type),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          backgroundColor: isSelected
              ? secondary.withValues(alpha: 0.12)
              : theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(
              color: isSelected ? secondary : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomText(
                label,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: secondary, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
