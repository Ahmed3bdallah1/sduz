import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/address/bloc/address_bloc.dart';
import 'package:sudz/features/address/bloc/address_state.dart';
import 'package:sudz/features/address/ui/widgets/address_picker_bottom_sheet.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(120.h);

  void _showAddressPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AddressBloc>(),
        child: const AddressPickerBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 20.w,
      toolbarHeight: preferredSize.height,
      backgroundColor: theme.colorScheme.surface,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppTheme.outlineLight),
      ),
      title: BlocBuilder<AddressBloc, AddressState>(
        buildWhen: (prev, curr) => prev.selectedAddress != curr.selectedAddress,
        builder: (context, state) {
          final selectedName =
              state.selectedAddress?.title ?? 'اختر العنوان المناسب';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomText(
                    'أهلاً عبدالله',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 0.w),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_none_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showAddressPicker(context),
                child: Container(
                  height: 50.h,

                  decoration: BoxDecoration(
                    color: Color(0xffF9FAFB),
                    borderRadius: BorderRadius.circular(15.sp),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(width: 10.w),
                        Image.asset(
                          'assets/icons/Frame.png',
                          width: 24.sp,
                          height: 25.sp,
                        ),
                        SizedBox(width: 6.w),
                        CustomTextBody(
                          selectedName,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.textPrimary,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
            ],
          );
        },
      ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsetsDirectional.only(end: 20.w),
      //     child: DecoratedBox(
      //       decoration: BoxDecoration(
      //         color: theme.colorScheme.primary.withValues(alpha: 0.08),
      //         borderRadius: BorderRadius.circular(16.r),
      //       ),
      //       child: IconButton(
      //         icon: Icon(
      //           Icons.notifications_none_outlined,
      //           color: theme.colorScheme.primary,
      //         ),
      //         onPressed: () {},
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
