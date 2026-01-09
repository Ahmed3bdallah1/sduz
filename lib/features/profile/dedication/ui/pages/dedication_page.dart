import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/features/profile/dedication/bloc/dedication_bloc.dart';
import 'package:sudz/features/profile/dedication/bloc/dedication_event.dart';
import 'package:sudz/features/profile/dedication/bloc/dedication_state.dart';
import 'package:sudz/features/profile/dedication/ui/widgets/dedication_type_sheet.dart';
import 'package:sudz/features/profile/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_button.dart';
import 'package:sudz/shared/widgets/custom_text.dart';
import 'package:sudz/shared/widgets/custom_text_field.dart';

class DedicationPage extends StatelessWidget {
  const DedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DedicationBloc>()..add(const DedicationStarted()),
      child: const _DedicationView(),
    );
  }
}

class _DedicationView extends StatefulWidget {
  const _DedicationView();

  @override
  State<_DedicationView> createState() => _DedicationViewState();
}

class _DedicationViewState extends State<_DedicationView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'profile.dedication.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<DedicationBloc, DedicationState>(
        listenWhen: (previous, current) =>
            previous.phoneNumber != current.phoneNumber ||
            previous.selectedTypeId != current.selectedTypeId ||
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) async {
          if (_phoneController.text != state.phoneNumber) {
            _phoneController.value = TextEditingValue(
              text: state.phoneNumber,
              selection: TextSelection.collapsed(
                offset: state.phoneNumber.length,
              ),
            );
          }

          final selectedTypeTitle = state.selectedType?.title ?? '';
          if (_typeController.text != selectedTypeTitle) {
            _typeController.text = selectedTypeTitle;
          }

          if (state.status.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('profile.dedication.success'.tr())),
            );
            context.read<DedicationBloc>().add(
              const DedicationFeedbackCleared(),
            );
          } else if (state.status.isFailure && state.errorMessage != null) {
            final message = state.errorMessage!;
            final errorText = message.startsWith('profile.')
                ? message.tr()
                : message;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorText)));
            context.read<DedicationBloc>().add(
              const DedicationFeedbackCleared(),
            );
          }
        },
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure && state.types.isEmpty) {
            return Center(
              child: CustomTextBody(
                'profile.dedication.load_failure'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextBody(
                    'profile.dedication.subtitle'.tr(),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  SizedBox(height: 24.h),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: 'profile.dedication.phone_hint'.tr(),
                    keyboardType: TextInputType.phone,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    onChanged: (value) => context.read<DedicationBloc>().add(
                      DedicationPhoneChanged(value),
                    ),
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: _typeController,
                    hintText: 'profile.dedication.type_hint'.tr(),
                    readOnly: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (state.types.isEmpty) return;

                      final selected =
                          await showModalBottomSheet<ProfileDedicationType>(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24.r),
                              ),
                            ),
                            builder: (_) => DedicationTypeSheet(
                              types: state.types,
                              selectedTypeId: state.selectedTypeId,
                            ),
                          );

                      if (!context.mounted) return;

                      if (selected != null) {
                        context.read<DedicationBloc>().add(
                          DedicationTypeSelected(selected.id),
                        );
                      }
                    },
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  CustomPrimaryButton(
                    text: 'profile.dedication.submit'.tr(),
                    onPressed: state.status.isSubmitting
                        ? null
                        : () => context.read<DedicationBloc>().add(
                            const DedicationSubmitted(),
                          ),
                    isLoading: state.status.isSubmitting,
                    height: 40.h,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
