import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class ServiceCheckoutOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;
  final Widget? trailing;

  const ServiceCheckoutOptionCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderColor = isSelected
        ? colorScheme.secondary
        : colorScheme.outline.withValues(alpha: 0.6);

    final textColor = isEnabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.35);

    return Opacity(
      opacity: isEnabled ? 1 : 0.65,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor, width: 1.6),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppTheme.secondaryLight.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.secondary
                        : colorScheme.secondary.withValues(alpha: 0.35),
                    width: 1.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? colorScheme.secondary
                        : Colors.transparent,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      subtitle,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[SizedBox(width: 12.w), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
