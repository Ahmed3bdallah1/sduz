import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.height,
    this.letterSpacing,
    this.fontStyle,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? height;
  final double? letterSpacing;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize?.sp,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
        decoration: decoration,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      ),
    );
  }
}

// Title variants
class CustomTextTitle extends StatelessWidget {
  const CustomTextTitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomTextHeadline extends StatelessWidget {
  const CustomTextHeadline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text.tr(),
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomTextSubtitle extends StatelessWidget {
  const CustomTextSubtitle(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: 13.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class CustomTextBody extends StatelessWidget {
  const CustomTextBody(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: 12.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class CustomTextCaption extends StatelessWidget {
  const CustomTextCaption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  });

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: 11.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Theme.of(context).textTheme.bodySmall?.color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
