import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoadingSpinner extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingSpinner({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 50.0,
    );
  }
}

class CustomLoadingFadingCircle extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingFadingCircle({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 50.0,
    );
  }
}

class CustomLoadingRotatingCircle extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingRotatingCircle({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitRotatingCircle(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 50.0,
    );
  }
}

class CustomLoadingThreeBounce extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingThreeBounce({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 30.0,
    );
  }
}

class CustomLoadingWave extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingWave({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 30.0,
    );
  }
}

class CustomLoadingPulse extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingPulse({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 50.0,
    );
  }
}

class CustomLoadingDots extends StatelessWidget {
  final Color? color;
  final double? size;

  const CustomLoadingDots({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size ?? 50.0,
    );
  }
}

// Full screen loading overlay
class CustomLoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const CustomLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomLoadingSpinner(
              color: Colors.white,
            ),
            if (message != null) ...[
              SizedBox(height: 20.h),
              Text(
                message!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Loading widget for lists or cards
class CustomLoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;

  const CustomLoadingWidget({
    super.key,
    this.message,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomLoadingSpinner(size: size),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Loading dialog
void showLoadingDialog(
  BuildContext context, {
  String? message,
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => PopScope(
      canPop: barrierDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomLoadingSpinner(),
              if (message != null) ...[
                SizedBox(height: 20.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

// Hide loading dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}
