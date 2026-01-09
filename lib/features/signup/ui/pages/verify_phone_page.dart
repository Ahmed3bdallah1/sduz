import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/auth/bloc/role_selection_cubit.dart';
import 'package:sudz/features/auth/bloc/verify_phone_bloc.dart';
import 'package:sudz/features/auth/bloc/verify_phone_event.dart';
import 'package:sudz/features/auth/bloc/verify_phone_state.dart';
import 'package:sudz/features/auth/domain/entities/verify_phone_result.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class VerifyPhoneArgs {
  const VerifyPhoneArgs({
    required this.phone,
    required this.messageKey,
    required this.name,
    required this.email,
    required this.role,
  });

  final String phone;
  final String messageKey;
  final String name;
  final String email;
  final AuthRole role;
}

class VerifyPhonePage extends StatelessWidget {
  const VerifyPhonePage({super.key, required this.args});

  final VerifyPhoneArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyPhoneBloc>(param1: args.phone),
      child: VerifyPhoneView(args: args),
    );
  }
}

class VerifyPhoneView extends StatelessWidget {
  VerifyPhoneView({super.key, required this.args});

  final VerifyPhoneArgs args;
  final RegExp _messageKeyPattern = RegExp(r'^[a-z0-9_.]+$');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('auth.verify_phone.title'.tr()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: BlocConsumer<VerifyPhoneBloc, VerifyPhoneState>(
            listener: (context, state) async {
              if (state.status == VerifyPhoneStatus.success &&
                  state.result != null) {
                await _handleSuccess(context, state.result!);
              } else if (state.status == VerifyPhoneStatus.failure &&
                  state.errorMessage != null) {
                _handleError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 32.h),
                  CustomTextBody(
                    _localizeMessage(context, args.messageKey),
                    color: isDark
                        ? Colors.grey.shade300
                        : theme.colorScheme.onSurface,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  CustomTextBody(
                    'auth.verify_phone.subtitle'.tr(
                      namedArgs: {'phone': args.phone},
                    ),
                    color: isDark
                        ? Colors.grey.shade400
                        : theme.colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  CustomTextField(
                    labelText: 'auth.verify_phone.code_label'.tr(),
                    hintText: 'auth.verify_phone.code_hint'.tr(),
                    textAlign: TextAlign.center,
                    // textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => context.read<VerifyPhoneBloc>().add(
                      VerifyPhoneCodeChangedEvent(value),
                    ),
                    errorText: state.fieldError('code'),
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    text: 'auth.verify_phone.submit_button'.tr(),
                    onPressed: () => context.read<VerifyPhoneBloc>().add(
                      const VerifyPhoneSubmittedEvent(),
                    ),
                    isLoading: state.status == VerifyPhoneStatus.loading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleSuccess(
    BuildContext context,
    VerifyPhoneResult result,
  ) async {
    await showSuccessDialog(
      context,
      title: 'auth.verify_phone.success_title',
      message: _localizeMessage(context, result.message),
    );
    if (!context.mounted) return;
    final targetRoute = args.role.isTechnical
        ? RouteNames.techHome
        : RouteNames.home;
    context.goNamed(targetRoute);
  }

  void _handleError(BuildContext context, String message) {
    showErrorDialog(
      context,
      message: _localizeMessage(context, message),
    );
  }

  String _localizeMessage(BuildContext context, String message) {
    if (_messageKeyPattern.hasMatch(message)) {
      return message.tr();
    }
    return message;
  }
}
