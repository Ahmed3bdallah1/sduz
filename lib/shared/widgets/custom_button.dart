import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_loading.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final Widget? icon;
  final BorderSide? borderSide;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.icon,
    this.borderSide,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;
    final defaultTextColor =
        textColor ?? Theme.of(context).colorScheme.onPrimary;

    final resolvedBorderRadius = borderRadius ?? 12.0;
    final resolvedHeight = height?.h ?? 48.h;

    final buttonChild = isLoading
        ? CustomLoadingSpinner(
            color: isOutlined ? defaultBackgroundColor : defaultTextColor,
            size: 20,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, SizedBox(width: 6.w)],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize?.sp ?? 16.sp,
                  fontWeight: fontWeight ?? FontWeight.w600,
                  color: isOutlined ? defaultBackgroundColor : defaultTextColor,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width?.w,
      height: resolvedHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side:
                    borderSide ??
                    BorderSide(color: defaultBackgroundColor, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(resolvedBorderRadius),
                ),
                padding:
                    padding ??
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(resolvedBorderRadius),
                ),
                padding:
                    padding ??
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: buttonChild,
            ),
    );
  }
}

// Primary Button
class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
    );
  }
}

// Secondary/Outlined Button
class CustomSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;

  const CustomSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      isOutlined: true,
    );
  }
}

// Text Button
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? icon;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 6.w)],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize?.sp ?? 14.sp,
              fontWeight: fontWeight ?? FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: color ?? Theme.of(context).colorScheme.primary,
              decorationThickness: 0.3,
              decorationStyle: TextDecorationStyle.solid,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// Icon Button
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final double? iconSize;
  final String? tooltip;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: size?.w ?? 40.w,
      height: size?.h ?? 40.h,
      decoration: backgroundColor != null
          ? BoxDecoration(color: backgroundColor, shape: BoxShape.circle)
          : null,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: iconSize?.sp ?? 24.sp,
          color: color ?? Theme.of(context).iconTheme.color,
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
  }
}
