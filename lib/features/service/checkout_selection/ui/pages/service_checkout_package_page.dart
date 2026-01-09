import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import 'package:sudz/features/service/models/models.dart';

class ServiceCheckoutPackagePage extends StatelessWidget {
  final ServicePackage package;

  const ServiceCheckoutPackagePage({required this.package, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'service.checkout.package_title'.tr(),
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color:
              theme.appBarTheme.titleTextStyle?.color ??
              theme.colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              package.name,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            SizedBox(height: 8.h),
            CustomText(
              'service.checkout.package_placeholder'.tr(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
