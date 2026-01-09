import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/home/models/models.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class HomeBestSellerList extends StatelessWidget {
  final List<HomePackage> packages;

  const HomeBestSellerList({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(start: 0.w, end: 0.w),
        itemBuilder: (_, index) {
          final package = packages[index];
          return _BestSellerCard(package: package);
        },
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemCount: packages.length,
      ),
    );
  }
}

class _BestSellerCard extends StatelessWidget {
  final HomePackage package;

  const _BestSellerCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 148.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: CustomNetworkImage(
              imageUrl:
                  'https://assets.gulfoilltd.com/gomel/files/styles/large/public/2022-09/Max10W30-4L.jpg?VersionId=tp4mA4BoxqusRagF7fUgGV4LywhHZZmL&itok=-1JdHLyN',
              height: 90.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Gulf MAX',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: theme.colorScheme.onSurface,
                ),
                Spacer(),
                CustomTextCaption(
                  '${package.price.toStringAsFixed(0)} ${package.priceUnit}',
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ElevatedButton(
              onPressed: () {
                context.push(RouteNames.storeCart);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(148.w, 20.h),
                backgroundColor: AppTheme.primaryLight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.white),
                  SizedBox(width: 10.w),
                  CustomText('اضافة', color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
