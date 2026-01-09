import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class StoreProductCard extends StatelessWidget {
  final StoreProduct product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const StoreProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYx_oR-0dTYaaZyJNNiRRtbAQNQpgRkHC8yg&s',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            CustomText(
              product.nameKey.tr(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 6.h),
            // CustomText(
            //   product.descriptionKey.tr(),
            //   maxLines: 1,
            //   fontSize: 12.sp,
            //   overflow: TextOverflow.ellipsis,
            //   color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            // ),
            // SizedBox(height: 10.h),
            CustomText(
              'store.currency_value'.tr(
                namedArgs: {'value': product.price.toStringAsFixed(1)},
              ),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: 12.h),
            // CustomButton(
            //   text: 'store.action.add_to_cart'.tr(),
            //   onPressed: onAddToCart,
            //   height: 40.h,
            //   width: double.infinity,
            //   fontSize: 11.sp,
            //   borderRadius: 12,
            // ),
            ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                textStyle: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Icon(Icons.shopping_cart_outlined, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}
