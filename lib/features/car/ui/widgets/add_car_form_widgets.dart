import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/car/domain/entities/car_size.dart';
import 'package:sudz/shared/widgets/custom_network_image.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class AddCarImagePicker extends StatelessWidget {
  const AddCarImagePicker({
    super.key,
    required this.imagePath,
    required this.onImageSelected,
  });

  final String? imagePath;
  final ValueChanged<String> onImageSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onImageSelected(_sampleCarImage),
      child: Container(
        width: double.infinity,
        height: 140.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: imagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 32.w,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextBody(
                    'اضغط لإضافة صورة',
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: CustomNetworkImage(
                  imageUrl: imagePath!,
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

class AddCarTextField extends StatelessWidget {
  const AddCarTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value,
      onChanged: onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}

class AddCarSizeDropdown extends StatelessWidget {
  const AddCarSizeDropdown({
    super.key,
    required this.sizes,
    required this.selectedId,
    required this.onChanged,
  });

  final List<CarSize> sizes;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<int>(
      initialValue: selectedId,
      isExpanded: true,
      items: sizes
          .map(
            (size) => DropdownMenuItem<int>(
              value: size.id,
              child: CustomTextBody(size.name, fontWeight: FontWeight.w500),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'فئة حجم السيارة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.transparent, width: 1.2),
        ),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

const String _sampleCarImage =
    'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=600&q=80';
