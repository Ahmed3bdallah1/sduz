import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'custom_button.dart';
import 'custom_text.dart';

final RegExp _dialogKeyPattern = RegExp(r'^[a-z0-9_.]+$');

String _resolveDialogText(BuildContext context, String value) {
  if (_dialogKeyPattern.hasMatch(value)) {
    return value.tr();
  }
  return value;
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? positiveText;
  final String? negativeText;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  final Widget? icon;
  final Color? iconColor;
  final bool barrierDismissible;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.positiveText,
    this.negativeText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.icon,
    this.iconColor,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: (iconColor ?? Theme.of(context).colorScheme.primary)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: iconColor ?? Theme.of(context).colorScheme.primary,
                    size: 32.sp,
                  ),
                  child: icon!,
                ),
              ),
              SizedBox(height: 16.h),
            ],
            CustomTextHeadline(
              title.tr(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomTextBody(
              message.tr(),
              textAlign: TextAlign.center,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                if (negativeText != null)
                  Expanded(
                    child: CustomSecondaryButton(
                      text: negativeText!.tr(),
                      onPressed: onNegativePressed ??
                          () => Navigator.of(context).pop(false),
                    ),
                  ),
                if (negativeText != null && positiveText != null)
                  SizedBox(width: 12.w),
                if (positiveText != null)
                  Expanded(
                    child: CustomPrimaryButton(
                      text: positiveText!.tr(),
                      onPressed: onPositivePressed ??
                          () => Navigator.of(context).pop(true),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Confirmation Dialog
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'common.confirm',
    this.cancelText = 'common.cancel',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      positiveText: confirmText,
      negativeText: cancelText,
      onPositivePressed: onConfirm ?? () => Navigator.of(context).pop(true),
      onNegativePressed: onCancel ?? () => Navigator.of(context).pop(false),
      icon: const Icon(Icons.help_outline),
    );
  }
}

// Success Dialog
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'common.ok',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      positiveText: buttonText,
      onPositivePressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.check_circle_outline),
      iconColor: Colors.green,
    );
  }
}

// Error Dialog
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    this.title = 'common.error_title',
    required this.message,
    this.buttonText = 'common.ok',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      positiveText: buttonText,
      onPositivePressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.error_outline),
      iconColor: Colors.red,
    );
  }
}

// Warning Dialog
class WarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const WarningDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'common.confirm',
    this.cancelText = 'common.cancel',
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      positiveText: confirmText,
      negativeText: cancelText,
      onPositivePressed: onConfirm ?? () => Navigator.of(context).pop(true),
      onNegativePressed: onCancel ?? () => Navigator.of(context).pop(false),
      icon: const Icon(Icons.warning_amber_outlined),
      iconColor: Colors.orange,
    );
  }
}

// Info Dialog
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'common.ok',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      positiveText: buttonText,
      onPositivePressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.info_outline),
      iconColor: Colors.blue,
    );
  }
}

// Helper functions to show dialogs
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'common.confirm',
  String cancelText = 'common.cancel',
}) {
  final resolvedTitle = _resolveDialogText(context, title);
  final resolvedMessage = _resolveDialogText(context, message);
  final resolvedConfirm = _resolveDialogText(context, confirmText);
  final resolvedCancel = _resolveDialogText(context, cancelText);
  return showDialog<bool>(
    context: context,
    builder: (context) => ConfirmationDialog(
      title: resolvedTitle,
      message: resolvedMessage,
      confirmText: resolvedConfirm,
      cancelText: resolvedCancel,
    ),
  );
}

Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'common.ok',
}) {
  return showDialog(
    context: context,
    builder: (context) => SuccessDialog(
      title: _resolveDialogText(context, title),
      message: _resolveDialogText(context, message),
      buttonText: _resolveDialogText(context, buttonText),
    ),
  );
}

Future<void> showErrorDialog(
  BuildContext context, {
  String title = 'common.error_title',
  required String message,
  String buttonText = 'common.ok',
}) {
  return showDialog(
    context: context,
    builder: (context) => ErrorDialog(
      title: _resolveDialogText(context, title),
      message: _resolveDialogText(context, message),
      buttonText: _resolveDialogText(context, buttonText),
    ),
  );
}

Future<bool?> showWarningDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'common.confirm',
  String cancelText = 'common.cancel',
}) {
  final resolvedTitle = _resolveDialogText(context, title);
  final resolvedMessage = _resolveDialogText(context, message);
  final resolvedConfirm = _resolveDialogText(context, confirmText);
  final resolvedCancel = _resolveDialogText(context, cancelText);
  return showDialog<bool>(
    context: context,
    builder: (context) => WarningDialog(
      title: resolvedTitle,
      message: resolvedMessage,
      confirmText: resolvedConfirm,
      cancelText: resolvedCancel,
    ),
  );
}

Future<void> showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'common.ok',
}) {
  return showDialog(
    context: context,
    builder: (context) => InfoDialog(
      title: _resolveDialogText(context, title),
      message: _resolveDialogText(context, message),
      buttonText: _resolveDialogText(context, buttonText),
    ),
  );
}

// Custom bottom sheet dialog
void showCustomBottomSheet(
  BuildContext context, {
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
}) {
  showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.r),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.all(20.w),
      child: child,
    ),
  );
}
