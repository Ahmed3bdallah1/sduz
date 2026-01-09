import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class MyCarActionsSheet extends StatelessWidget {
  const MyCarActionsSheet({
    super.key,
    this.onEdit,
    required this.onDelete,
    this.onSetPrimary,
  });

  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null) ...[
            _SheetActionButton(
              label: 'profile.cars.edit'.tr(),
              onPressed: onEdit!,
              textColor: theme.colorScheme.onSurface,
            ),
            SizedBox(height: 12.h),
          ],
          if (onSetPrimary != null) ...[
            _SheetActionButton(
              label: 'profile.cars.make_primary'.tr(),
              onPressed: onSetPrimary!,
              textColor: theme.colorScheme.primary,
            ),
            SizedBox(height: 12.h),
          ],
          _SheetActionButton(
            label: 'profile.cars.delete'.tr(),
            onPressed: onDelete,
            textColor: theme.colorScheme.error,
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color textColor;

  const _SheetActionButton({
    required this.label,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onPressed();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: CustomText(
          label,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
