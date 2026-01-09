import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/store/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class StoreCartItemTile extends StatelessWidget {
  final StoreCartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const StoreCartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              'https://m.media-amazon.com/images/I/412cGL-qePL._SR290,290_.jpg',
              width: 64.w,
              height: 64.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64.w,
                height: 64.w,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.product.nameKey.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                CustomTextBody(
                  'store.currency_value'.tr(
                    namedArgs: {'value': item.product.price.toStringAsFixed(1)},
                  ),
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF3F3F3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove),
                  color: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                ),
                CustomText(
                  '${item.quantity}',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add),
                  color: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
