import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/service/domain/entities/service.dart';
import 'package:sudz/shared/widgets/custom_text.dart';
import 'package:sudz/shared/widgets/custom_button.dart';

class HomeServiceList extends StatelessWidget {
  const HomeServiceList({super.key, required this.services});

  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: services.length,
        separatorBuilder: (_, __) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          final service = services[index];
          return HomeServiceCard(service: service);
        },
      ),
    );
  }
}

class HomeServiceCard extends StatelessWidget {
  const HomeServiceCard({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final localDb = await LocalDatabaseService.instance;
        final token = localDb.getToken();

        if (!context.mounted) return;

        if (token == null || token.isEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _ServiceLoginRequiredPage(),
            ),
          );
        } else {
          context.push(RouteNames.service, extra: service.id);
        }
      },
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            if (service.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  service.imageUrl!,
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100.h,
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    child: Icon(
                      Icons.local_car_wash,
                      size: 40.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_car_wash,
                    size: 40.sp,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

            // Service Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    service.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  CustomTextBody(
                    service.description,
                    // fontSize: 12.sp,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        '${service.price.toInt()} ريال',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                      if (service.durationMinutes != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14.sp,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            CustomTextBody(
                              '${service.durationMinutes} د',
                              // fontSize: 12.sp,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceLoginRequiredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          'common.login_required_title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_car_wash_outlined,
                size: 80.sp,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
              SizedBox(height: 24.h),
              CustomText(
                'common.login_required_title'.tr(),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              CustomTextBody(
                'common.login_required_message'.tr(),
                textAlign: TextAlign.center,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(height: 32.h),
              CustomButton(
                text: 'common.login_button'.tr(),
                onPressed: () {
                  // Pop this page first
                  Navigator.of(context).pop();
                  // Then navigate to login
                  context.push(RouteNames.login);
                },
                backgroundColor: AppTheme.primaryLight,
                textColor: Colors.white,
                height: 48,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
