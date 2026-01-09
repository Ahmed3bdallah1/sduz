import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: CustomTextSubtitle(
              title,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              // style: TextButton.styleFrom(
              //   foregroundColor: theme.colorScheme.primary,
              //   textStyle: TextStyle(
              //     fontSize: 13.sp,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              child: CustomText(
                actionLabel!,
                fontSize: 12.sp,
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
