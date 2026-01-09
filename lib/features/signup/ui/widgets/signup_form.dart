import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/auth/bloc/role_selection_cubit.dart';
import 'package:sudz/features/auth/domain/entities/signup_result.dart';
import 'package:sudz/shared/widgets/widgets.dart';

// import '../../bloc/role_selection_cubit.dart';
import '../../bloc/signup_bloc.dart';
import '../../bloc/signup_event.dart';
import '../../bloc/signup_state.dart';

import '../pages/verify_phone_page.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  static final RegExp _messageKeyPattern = RegExp(r'^[a-z0-9_.]+$');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) async {
        if (state.status == SignupStatus.success && state.result != null) {
          await _handleSignupSuccess(context, state.result!);
        } else if (state.status == SignupStatus.failure &&
            state.errorMessage != null) {
          _handleSignupError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            CustomTextField(
              labelText: 'auth.signup.name_label'.tr(),
              hintText: 'auth.signup.name_hint'.tr(),
              errorText: state.fieldError('name'),
              keyboardType: TextInputType.name,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                ),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                context.read<SignupBloc>().add(SignupNameChangedEvent(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth.signup.name_error'.tr();
                }
                return null;
              },
            ),

            SizedBox(height: 20.h),

            // Phone number field
            CustomTextField(
              labelText: 'auth.signup.phone_label'.tr(),
              hintText: 'auth.signup.phone_hint'.tr(),
              errorText:
                  state.fieldError('phone') ?? state.fieldError('phone_number'),
              keyboardType: TextInputType.phone,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                ),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                context.read<SignupBloc>().add(
                  SignupPhoneNumberChangedEvent(value),
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth.signup.phone_error'.tr();
                }
                return null;
              },
            ),

            SizedBox(height: 20.h),

            // Email field
            CustomTextField(
              labelText: 'auth.signup.email_label'.tr(),
              hintText: 'auth.signup.email_hint'.tr(),
              errorText: state.fieldError('email'),
              keyboardType: TextInputType.emailAddress,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                ),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                context.read<SignupBloc>().add(SignupEmailChangedEvent(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth.signup.email_error'.tr();
                }
                return null;
              },
            ),

            SizedBox(height: 20.h),

            // Password field
            BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                return CustomTextField(
                  labelText: 'auth.signup.password_label'.tr(),
                  hintText: 'auth.signup.password_hint'.tr(),
                  errorText: state.fieldError('password'),
                  obscureText: !state.isPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppTheme.primaryDark
                          : AppTheme.primaryLight,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    context.read<SignupBloc>().add(
                      SignupPasswordChangedEvent(value),
                    );
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      context.read<SignupBloc>().add(
                        const SignupTogglePasswordVisibilityEvent(),
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.signup.password_error_empty'.tr();
                    }
                    if (value.length < 6) {
                      return 'auth.signup.password_error_length'.tr();
                    }
                    return null;
                  },
                );
              },
            ),

            SizedBox(height: 24.h),

            // Signup button
            CustomButton(
              text: 'auth.signup.signup_button'.tr(),
              onPressed: () {
                context.read<SignupBloc>().add(
                  SignupSubmitEvent(
                    name: state.name,
                    phoneNumber: state.phoneNumber,
                    email: state.email,
                    password: state.password,
                  ),
                );
              },
              isLoading: state.status == SignupStatus.loading,
              backgroundColor: AppTheme.primaryLight,
              textColor: Colors.white,
              height: 50,
              borderRadius: 8,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignupSuccess(
    BuildContext context,
    SignupResult result,
  ) async {
    final message = _localizeMessage(context, result.message);
    final role = context.read<RoleSelectionCubit>().state.role;

    await showSuccessDialog(
      context,
      title: 'auth.signup.success_title',
      message: message,
    );
    if (!context.mounted) return;

    context.pushNamed(
      RouteNames.verifyPhone,
      extra: VerifyPhoneArgs(
        phone: result.user.phone,
        messageKey: result.message,
        name: result.user.name,
        email: result.user.email,
        role: role,
      ),
    );
  }

  void _handleSignupError(BuildContext context, String message) {
    showErrorDialog(context, message: _localizeMessage(context, message));
  }

  String _localizeMessage(BuildContext context, String message) {
    if (_messageKeyPattern.hasMatch(message)) {
      return message.tr();
    }
    return message;
  }
}
