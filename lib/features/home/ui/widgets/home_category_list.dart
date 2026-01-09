import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/home/models/models.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/routing/route_names.dart';

class HomeCategoryList extends StatelessWidget {
  final List<HomeCategory> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const HomeCategoryList({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // Maximum 4 categories to display
    const maxCategories = 4;
    final hasMoreCategories = categories.length > maxCategories;

    // If more than 4, show first 3 + "Others"
    final displayCategories = hasMoreCategories
        ? categories.take(maxCategories - 1).toList()
        : categories;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Display regular categories
        ...List.generate(displayCategories.length, (i) {
          return _CategoryChip(
            category: displayCategories[i],
            isSelected: displayCategories[i].id == selectedId,
            onTap: () async {
              final localDb = await LocalDatabaseService.instance;
              final token = localDb.getToken();

              if (!context.mounted) return;

              if (token == null || token.isEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => _CategoryLoginRequiredPage(),
                  ),
                );
              } else {
                onSelected(displayCategories[i].id);
                context.push(
                  RouteNames.service,
                  extra: displayCategories[i].id,
                );
              }
            },
          );
        }),

        // Add "Others" category if there are more categories
        if (hasMoreCategories)
          _CategoryChip(
            category: HomeCategory(
              id: 'all_services',
              title: 'home.others_category'.tr(),
              icon: Icons.apps,
              backgroundColor: const Color(0xFFF0F4F8),
            ),
            isSelected: false,
            onTap: () async {
              final localDb = await LocalDatabaseService.instance;
              final token = localDb.getToken();

              if (!context.mounted) return;

              if (token == null || token.isEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => _CategoryLoginRequiredPage(),
                  ),
                );
              } else {
                context.push(RouteNames.service);
              }
            },
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final HomeCategory category;
  final VoidCallback onTap;
  final bool isSelected;

  const _CategoryChip({
    required this.category,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 70.h,
            width: 70.w,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? theme.colorScheme.primary
                  : category.backgroundColor,
              // borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Icon(
              category.icon,
              size: 20.sp,
              color: isSelected ? Colors.white : theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 6.h),
          CustomText(category.title, fontSize: 12.sp),
        ],
      ),
    );
  }
}

class _CategoryLoginRequiredPage extends StatelessWidget {
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
                Icons.category_outlined,
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
                  Navigator.of(context).pop();
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
