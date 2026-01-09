import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sudz/features/orders/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class OrdersBookingCard extends StatelessWidget {
  final OrderBooking booking;

  const OrdersBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat(
      'd MMMM yyyy, h:mm a',
      'ar',
    ).format(booking.scheduledAt);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFFB0B9C4),
              ),
              SizedBox(width: 8.w),
              CustomText(
                formattedDate,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomText(
            booking.serviceName,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          SizedBox(height: 8.h),
          CustomTextBody(
            booking.status,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
          if (booking.address != null) ...[
            SizedBox(height: 8.h),
            CustomTextBody(
              booking.address!,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            CustomTextCaption(
              booking.notes!,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              maxLines: 3,
              textAlign: TextAlign.justify,
            ),
          ],
        ],
      ),
    );
  }
}
