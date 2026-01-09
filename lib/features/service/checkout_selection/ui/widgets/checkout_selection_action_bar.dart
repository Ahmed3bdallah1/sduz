import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class ServiceCheckoutSelectionActionBar extends StatelessWidget {
  final VoidCallback onContinue;
  final bool isEnabled;
  final bool isLoading;
  final String summaryLabel;
  final String summaryValue;
  final String buttonLabel;
  final String? helperMessage;

  const ServiceCheckoutSelectionActionBar({
    required this.onContinue,
    required this.isEnabled,
    required this.isLoading,
    required this.summaryLabel,
    required this.summaryValue,
    required this.buttonLabel,
    this.helperMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 100.h,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      summaryLabel,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      summaryValue,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                    if (helperMessage != null) ...[
                      SizedBox(height: 4.h),
                      CustomText(
                        helperMessage!,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  text: buttonLabel,
                  onPressed: isEnabled ? onContinue : null,
                  isLoading: isLoading,
                  backgroundColor: theme.colorScheme.secondary,
                  textColor: theme.colorScheme.onSecondary,
                  borderRadius: 16.r,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
