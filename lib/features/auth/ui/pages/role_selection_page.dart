import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import '../../bloc/role_selection_cubit.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'auth.role_selection.title'.tr(),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppTheme.textPrimary,
              ),
              SizedBox(height: 8.h),
              CustomTextBody(
                'auth.role_selection.subtitle'.tr(),
                color: isDark ? Colors.grey.shade400 : AppTheme.textSecondary,
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: BlocBuilder<RoleSelectionCubit, RoleSelectionState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        _RoleCard(
                          title: 'auth.role_selection.client_title'.tr(),
                          subtitle: 'auth.role_selection.client_description'
                              .tr(),
                          icon: Icons.person_outline,
                          isSelected: state.role.isClient,
                          onTap: () {
                            context.read<RoleSelectionCubit>().selectRole(
                              AuthRole.client,
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        _RoleCard(
                          title: 'auth.role_selection.technical_title'.tr(),
                          subtitle: 'auth.role_selection.technical_description'
                              .tr(),
                          icon: Icons.handyman_outlined,
                          isSelected: state.role.isTechnical,
                          onTap: () {
                            context.read<RoleSelectionCubit>().selectRole(
                              AuthRole.technical,
                            );
                          },
                        ),
                        const Spacer(),
                        CustomButton(
                          text: state.role.isTechnical
                              ? 'auth.role_selection.continue_technical'.tr()
                              : 'auth.role_selection.continue_client'.tr(),
                          onPressed: () {
                            context.push(RouteNames.login);
                          },
                          height: 50,
                          borderRadius: 14,
                          backgroundColor: AppTheme.primaryLight,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 16.h),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6.w,
                            children: [
                              CustomTextBody(
                                'auth.role_selection.already_have_account'.tr(),
                                color: isDark
                                    ? Colors.grey.shade400
                                    : AppTheme.textSecondary,
                              ),
                              CustomTextButton(
                                text: 'auth.role_selection.login_link'.tr(),
                                onPressed: () {
                                  context.push(RouteNames.login);
                                },
                                color: AppTheme.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isSelected
        ? AppTheme.primaryLight
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade300);

    final backgroundColor = isSelected
        ? AppTheme.primaryLight.withValues(alpha: 0.08)
        : (isDark ? Colors.black : Colors.white);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1.1),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppTheme.primaryLight, size: 26.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppTheme.textPrimary,
                  ),
                  SizedBox(height: 6.h),
                  CustomTextBody(
                    subtitle,
                    color: isDark
                        ? Colors.grey.shade400
                        : AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppTheme.primaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
