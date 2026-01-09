import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/packages/data/models/models.dart';
import 'package:sudz/shared/widgets/custom_button.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackageConfirmationPage extends StatelessWidget {
  final Package package;

  const PackageConfirmationPage({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizedTitle = package.title.tr();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 180.h,
                      width: 180.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_rounded,
                        color: theme.colorScheme.secondary,
                        size: 96.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    CustomText(
                      'packages.confirmation.title'.tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextBody(
                      'packages.confirmation.subtitle'.tr(
                        namedArgs: {'name': localizedTitle},
                      ),
                      textAlign: TextAlign.center,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'packages.confirmation.back_to_packages'.tr(),
                  onPressed: () => context.goNamed(RouteNames.home),
                  height: 40.h,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
