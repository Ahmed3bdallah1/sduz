import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import '../../../../core/routing/route_names.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/login_event.dart';
import '../../bloc/login_state.dart';
import '../../bloc/role_selection_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status.isSuccess) {
          final role = context.read<RoleSelectionCubit>().state.role;
          // Navigate to home
          await showSuccessDialog(
            context,
            title: 'auth.login.success_title'.tr(),
            message: 'auth.login.success_message'.tr(),
          );
          if (!context.mounted) return;
          final targetRoute = role.isTechnical
              ? RouteNames.techHome
              : RouteNames.home;
          context.goNamed(targetRoute);
        } else if (state.hasError) {
          showErrorDialog(
            context,
            message: state.errorMessage ?? 'auth.login.error_message'.tr(),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email/Phone field
            CustomTextField(
              labelText: 'auth.login.email_or_phone_label'.tr(),
              hintText: 'auth.login.email_or_phone_hint'.tr(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                context.read<LoginBloc>().add(LoginEmailChangedEvent(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth.login.email_or_phone_error'.tr();
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // Password field
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return CustomTextField(
                  labelText: 'auth.login.password_label'.tr(),
                  hintText: 'auth.login.password_hint'.tr(),
                  obscureText: !state.isPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    context.read<LoginBloc>().add(
                      LoginPasswordChangedEvent(value),
                    );
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        const LoginTogglePasswordVisibilityEvent(),
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.login.password_error_empty'.tr();
                    }
                    if (value.length < 6) {
                      return 'auth.login.password_error_length'.tr();
                    }
                    return null;
                  },
                );
              },
            ),

            // SizedBox(height: 12.h),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: CustomTextButton(
                text: 'auth.login.forgot_password'.tr(),
                onPressed: () {},
                color: AppTheme.primaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 24.h),

            // Login button
            CustomButton(
              text: 'auth.login.login_button'.tr(),
              onPressed: () {
                context.read<LoginBloc>().add(
                  LoginSubmitEvent(
                    emailOrPhone: state.emailOrPhone,
                    password: state.password,
                  ),
                );
              },
              isLoading: state.isLoading,
              backgroundColor: AppTheme.primaryLight,
              textColor: Colors.white,
              height: 48,
              borderRadius: 12,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        );
      },
    );
  }
}
