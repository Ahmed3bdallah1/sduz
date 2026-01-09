import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_text.dart';
import '../../../service/models/models.dart';

class ServiceTypeSection extends StatelessWidget {
  final List<ServiceType> serviceTypes;
  final String? selectedServiceTypeId;
  final Set<String> expandedServiceTypeIds;
  final ValueChanged<ServiceType> onServiceSelected;
  final ValueChanged<ServiceType> onServiceExpansionToggled;

  const ServiceTypeSection({
    required this.serviceTypes,
    required this.selectedServiceTypeId,
    required this.expandedServiceTypeIds,
    required this.onServiceSelected,
    required this.onServiceExpansionToggled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'نوع الخدمة',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        SizedBox(height: 12.h),
        for (final type in serviceTypes) ...[
          ServiceTypeTile(
            serviceType: type,
            isSelected: type.id == selectedServiceTypeId,
            isExpanded: expandedServiceTypeIds.contains(type.id),
            onSelected: () => onServiceSelected(type),
            onToggleExpansion: () => onServiceExpansionToggled(type),
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}

class ServiceTypeTile extends StatelessWidget {
  final ServiceType serviceType;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onSelected;
  final VoidCallback onToggleExpansion;

  const ServiceTypeTile({
    required this.serviceType,
    required this.isSelected,
    required this.isExpanded,
    required this.onSelected,
    required this.onToggleExpansion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        // border: Border.all(
        //   color: isSelected
        //       ? colorScheme.primary
        //       : colorScheme.primary.withValues(alpha: 0.1),
        //   width: 1.5,
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onSelected,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? colorScheme.secondary
                          : colorScheme.secondary.withValues(alpha: 0.4),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            serviceType.title,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          SizedBox(height: 4.h),
                          CustomTextBody(
                            serviceType.subtitle,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: CustomText(
                        '${serviceType.price} ${serviceType.currency}',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10.h,
                  color: colorScheme.onSurface.withValues(alpha: 0.07),
                ),
                SizedBox(height: 12.h),
                _ServiceTileFooter(
                  isExpanded: isExpanded,
                  onToggle: onToggleExpansion,
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _ServiceDetailsList(steps: serviceType.steps),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceTileFooter extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ServiceTileFooter({required this.isExpanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onToggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(width: 4.w),
          CustomTextBody(
            'تفاصيل',
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          // SizedBox(width: 4.w),
          Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ServiceDetailsList extends StatelessWidget {
  final List<ServiceStep> steps;

  const _ServiceDetailsList({required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((step) {
        return Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                margin: EdgeInsetsDirectional.only(top: 6.h, end: 8.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextBody(
                      step.name,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    SizedBox(height: 2.h),
                    CustomTextCaption(
                      step.description,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
