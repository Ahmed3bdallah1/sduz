import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import '../../bloc/signup_bloc.dart';
import '../widgets/signup_form.dart';
import '../../../auth/bloc/role_selection_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/routing/route_names.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignupBloc>(),
      child: const SignupPageView(),
    );
  }
}

class SignupPageView extends StatelessWidget {
  const SignupPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final role = context.watch<RoleSelectionCubit>().state.role;
    final isTechnical = role.isTechnical;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 70.h),

              CustomTextTitle(
                "auth.signup.title".tr(),
                color: isDark ? Colors.white : AppTheme.textPrimary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              CustomTextBody(
                'auth.signup.subtitle'.tr(),
                color: isDark ? Colors.grey.shade400 : AppTheme.textSecondary,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.h),

              if (isTechnical) ...[
                SizedBox(height: 24.h),
                CustomTextBody(
                  'auth.signup.technical_not_available'.tr(),
                  color: isDark ? Colors.grey.shade400 : AppTheme.textSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'auth.login.back_to_roles'.tr(),
                  onPressed: () {
                    context.go(RouteNames.roleSelection);
                  },
                  backgroundColor: AppTheme.primaryLight,
                  textColor: Colors.white,
                  height: 48,
                  borderRadius: 12,
                ),
              ] else ...[
                const SignupForm(),
              ],

              Spacer(),

              if (!isTechnical)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextBody(
                      'auth.signup.have_account'.tr(),
                      color: isDark
                          ? Colors.grey.shade400
                          : AppTheme.textSecondary,
                    ),
                    CustomTextButton(
                      text: 'auth.signup.login'.tr(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: AppTheme.primaryLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
