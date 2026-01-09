import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/role_selection_cubit.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final role = context.watch<RoleSelectionCubit>().state.role;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextButton(
                        text: 'auth.login.back_to_roles'.tr(),
                        onPressed: () {
                          context.go(RouteNames.roleSelection);
                        },
                        color: AppTheme.primaryLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 12.h),
                      CustomText(
                        role.isTechnical
                            ? 'auth.login.technical_title'.tr()
                            : 'auth.login.title'.tr(),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.textPrimary,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextBody(
                        role.isTechnical
                            ? 'auth.login.technical_subtitle'.tr()
                            : 'auth.login.subtitle'.tr(),
                        color: isDark
                            ? Colors.grey.shade400
                            : AppTheme.textSecondary,
                      ),
                      SizedBox(height: 32.h),
                      const LoginForm(),
                      SizedBox(height: 32.h),
                      if (role.isClient) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextBody(
                              'auth.login.no_account'.tr(),
                              color: isDark
                                  ? Colors.grey.shade400
                                  : AppTheme.textSecondary,
                            ),
                            SizedBox(width: 6.w),
                            CustomTextButton(
                              text: 'auth.login.create_account'.tr(),
                              onPressed: () {
                                context.push(RouteNames.signup);
                              },
                              color: AppTheme.primaryLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Center(
                          child: CustomTextButton(
                            text: 'auth.login.login_as_guest'.tr(),
                            onPressed: () {
                              context.goNamed(RouteNames.home);
                            },
                            color: AppTheme.primaryLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ] else ...[
                        Center(
                          child: CustomTextBody(
                            'auth.login.technical_no_signup'.tr(),
                            color: isDark
                                ? Colors.grey.shade400
                                : AppTheme.textSecondary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
