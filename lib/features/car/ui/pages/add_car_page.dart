import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/features/car/bloc/bloc.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import '../widgets/widgets.dart';

class AddCarPage extends StatelessWidget {
  const AddCarPage({super.key, this.initialCar});

  final UserCar? initialCar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<AddCarBloc>()..add(AddCarStarted(initialCar: initialCar)),
      child: const AddCarView(),
    );
  }
}

class AddCarView extends StatelessWidget {
  const AddCarView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          'سيارة جديدة',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color:
              theme.appBarTheme.titleTextStyle?.color ??
              theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AddCarBloc, AddCarState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.status.isFailure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomTextBody(
                  state.errorMessage!,
                  color: theme.colorScheme.onPrimary,
                ),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state.status.isSuccess && state.createdCar != null) {
            Navigator.of(context).pop(state.createdCar);
          }
        },
        child: BlocBuilder<AddCarBloc, AddCarState>(
          builder: (context, state) {
            final bloc = context.read<AddCarBloc>();

            if (state.status.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status.isFailure && state.carSizes.isEmpty) {
              return _AddCarError(
                message: state.errorMessage ?? 'حدث خطأ غير متوقع',
                onRetry: () => bloc.add(const AddCarStarted()),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddCarImagePicker(
                    imagePath: state.imagePath,
                    onImageSelected: (path) =>
                        bloc.add(AddCarImageChanged(path)),
                  ),
                  SizedBox(height: 24.h),
                  AddCarTextField(
                    label: 'اسم السيارة (اختياري)',
                    hintText: 'مثال: سيارة العائلة',
                    value: state.name,
                    onChanged: (value) => bloc.add(AddCarNameChanged(value)),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16.h),
                  AddCarTextField(
                    label: 'الشركة المصنعة',
                    value: state.brand,
                    onChanged: (value) => bloc.add(AddCarBrandChanged(value)),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16.h),
                  AddCarTextField(
                    label: 'موديل السيارة',
                    value: state.model,
                    onChanged: (value) => bloc.add(AddCarModelChanged(value)),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16.h),
                  AddCarTextField(
                    label: 'سنة الصنع',
                    value: state.year?.toString() ?? '',
                    onChanged: (value) => bloc.add(AddCarYearChanged(value)),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16.h),
                  AddCarTextField(
                    label: 'لون السيارة',
                    value: state.color,
                    onChanged: (value) => bloc.add(AddCarColorChanged(value)),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 16.h),
                  AddCarTextField(
                    label: 'رقم لوحة السيارة',
                    value: state.plateNumber,
                    onChanged: (value) => bloc.add(AddCarPlateChanged(value)),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 16.h),
                  AddCarSizeDropdown(
                    sizes: state.carSizes,
                    selectedId: state.selectedCarSizeId,
                    onChanged: (value) => bloc.add(AddCarSizeChanged(value)),
                  ),
                  SizedBox(height: 12.h),
                  SwitchListTile.adaptive(
                    value: state.isPrimary,
                    onChanged: (value) => bloc.add(AddCarPrimaryToggled(value)),
                    title: const Text('اجعلها السيارة الأساسية'),
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    text: state.isEditing ? 'تحديث السيارة' : 'حفظ السيارة',
                    onPressed: () => bloc.add(const AddCarSubmitted()),
                    isLoading: state.status.isSaving,
                    backgroundColor: theme.colorScheme.primary,
                    textColor: Colors.white,
                    height: 44.h,
                    width: MediaQuery.sizeOf(context).width,
                    borderRadius: 16.r,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddCarError extends StatelessWidget {
  const _AddCarError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 48.sp,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            CustomText(
              'تعذر تحميل البيانات',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            SizedBox(height: 8.h),
            CustomTextBody(
              message,
              textAlign: TextAlign.center,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            SizedBox(height: 20.h),
            CustomPrimaryButton(
              text: 'إعادة المحاولة',
              onPressed: onRetry,
              height: 40.h,
              width: 160.w,
            ),
          ],
        ),
      ),
    );
  }
}
