import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../bloc/address_bloc.dart';
import '../../bloc/address_event.dart';
import '../../bloc/address_state.dart';
import '../../domain/entities/user_address.dart';
import '../pages/address_form_page.dart';

class AddressPickerBottomSheet extends StatelessWidget {
  const AddressPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF3F3F3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              CustomText(
                'اختر العنوان',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              SizedBox(height: 16.h),
              Flexible(
                child: BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.addresses.isEmpty) {
                      return Center(
                        child: CustomTextBody(
                          'لا توجد عناوين متاحة حالياً',
                          color: theme.hintColor,
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.addresses.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        final isSelected =
                            address.id == state.selectedAddress?.id;
                        return _AddressTile(
                          address: address,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<AddressBloc>().add(
                              AddressSelected(address.id),
                            );
                            Navigator.of(context).maybePop();
                          },
                          onEdit: () => _openForm(context, initial: address),
                          onDelete: () => _confirmDelete(context, address),
                          onSetDefault: address.isDefault
                              ? null
                              : () => context.read<AddressBloc>().add(
                                  AddressSetDefaultRequested(address.id),
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openForm(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.transparent,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  icon: Icon(Icons.add, size: 20.sp),
                  label: CustomText(
                    'عنوان جديد',
                    color: AppTheme.primaryLight,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openForm(BuildContext context, {UserAddress? initial}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<AddressBloc>(),
          child: AddressFormPage(initialAddress: initial),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _confirmDelete(BuildContext context, UserAddress address) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: const Text('حذف العنوان'),
          content: Text('هل أنت متأكد من حذف ${address.title}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AddressBloc>().add(AddressDeleted(address.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final UserAddress address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : AppTheme.outlineLight,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : AppTheme.iconInactive,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomText(
                    address.title,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                PopupMenuButton<_AddressAction>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) {
                    switch (action) {
                      case _AddressAction.edit:
                        onEdit();
                        break;
                      case _AddressAction.delete:
                        onDelete();
                        break;
                      case _AddressAction.setDefault:
                        onSetDefault?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: _AddressAction.edit,
                      child: Text('تعديل'),
                    ),
                    const PopupMenuItem(
                      value: _AddressAction.delete,
                      child: Text('حذف'),
                    ),
                    PopupMenuItem(
                      enabled: onSetDefault != null,
                      value: _AddressAction.setDefault,
                      child: const Text('تعيين كافتراضي'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h),
            CustomText(
              address.shortDescription.isNotEmpty
                  ? address.shortDescription
                  : (address.description ?? ''),
              color: theme.hintColor,
              fontSize: 11.sp,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (address.isDefault) ...[
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: CustomText(
                  'العنوان الافتراضي',
                  fontSize: 10.sp,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _AddressAction { edit, delete, setDefault }
