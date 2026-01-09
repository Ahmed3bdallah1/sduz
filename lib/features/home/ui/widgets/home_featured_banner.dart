import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/home/models/models.dart';

class HomeFeaturedBanner extends StatelessWidget {
  // final HomePackage package;

  const HomeFeaturedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [theme.colorScheme.secondary, theme.colorScheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/4022350b1c49146c0dc9269f5ca7d853d92fc12c.png',
              fit: BoxFit.cover,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         theme.colorScheme.surface.withValues(alpha: 0.18),
            //         Colors.transparent,
            //       ],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.all(20.w),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           CustomText(
            //             package.title,
            //             fontSize: 22,
            //             fontWeight: FontWeight.w700,
            //             color: Colors.white,
            //           ),
            //           SizedBox(height: 8.h),
            //           CustomTextBody(
            //             package.description,
            //             color: Colors.white.withValues(alpha: 0.85),
            //             maxLines: 2,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ],
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(
            //           horizontal: 16.w,
            //           vertical: 10.h,
            //         ),
            //         decoration: BoxDecoration(
            //           color: Colors.white.withValues(alpha: 0.18),
            //           borderRadius: BorderRadius.circular(16.r),
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             _BannerStatChip(
            //               icon: Icons.schedule,
            //               label: '${package.durationMinutes} دقيقة',
            //             ),
            //             SizedBox(width: 12.w),
            //             _BannerStatChip(
            //               icon: Icons.shopping_bag_outlined,
            //               label: '${package.ordersCount} طلبات',
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
