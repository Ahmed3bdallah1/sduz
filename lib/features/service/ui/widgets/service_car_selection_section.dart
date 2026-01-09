import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/car/models/models.dart';
import 'package:sudz/shared/widgets/custom_network_image.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class ServiceCarSelectionSection extends StatelessWidget {
  final List<ServiceCar> cars;
  final String? selectedCarId;
  final ValueChanged<ServiceCar> onCarSelected;
  final VoidCallback onAddCar;

  const ServiceCarSelectionSection({
    required this.cars,
    required this.selectedCarId,
    required this.onCarSelected,
    required this.onAddCar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'حدد السيارة',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        SizedBox(height: 12.h),
        for (final car in cars) ...[
          ServiceCarTile(
            car: car,
            isSelected: car.id == selectedCarId,
            onTap: () => onCarSelected(car),
          ),
          SizedBox(height: 12.h),
        ],
        ServiceAddCarButton(onTap: onAddCar),
      ],
    );
  }
}

class ServiceCarTile extends StatelessWidget {
  final ServiceCar car;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCarTile({
    required this.car,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary.withValues(alpha: 0.1);
    final backgroundColor = isSelected
        ? theme.colorScheme.secondary.withValues(alpha: 0.1)
        : theme.colorScheme.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            _CarImage(imageUrl: car.imageUrl),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    car.displayName,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    ' ${car.colorName} - ${car.plateNumber}',
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.secondary.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarImage extends StatelessWidget {
  final String? imageUrl;

  const _CarImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 56.w,
        height: 56.w,
        color: Colors.grey.shade200,
        child: imageUrl == null
            ? Icon(
                Icons.directions_car,
                size: 28.w,
                color: Colors.grey.shade500,
              )
            : CustomNetworkImage(
                imageUrl: imageUrl!,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class ServiceAddCarButton extends StatelessWidget {
  final VoidCallback onTap;

  const ServiceAddCarButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 52.h),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
      icon: Icon(Icons.add, color: theme.colorScheme.primary),
      label: CustomText(
        'إضافة سيارة',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
