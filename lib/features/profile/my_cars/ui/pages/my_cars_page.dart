import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/features/profile/my_cars/bloc/my_cars_bloc.dart';
import 'package:sudz/features/profile/my_cars/bloc/my_cars_event.dart';
import 'package:sudz/features/profile/my_cars/bloc/my_cars_state.dart';
import 'package:sudz/features/profile/my_cars/ui/widgets/my_car_actions_sheet.dart';
import 'package:sudz/features/profile/my_cars/ui/widgets/my_car_card.dart';
import 'package:sudz/shared/widgets/custom_button.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class MyCarsPage extends StatelessWidget {
  const MyCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyCarsBloc>()..add(const MyCarsStarted()),
      child: const _MyCarsView(),
    );
  }
}

class _MyCarsView extends StatelessWidget {
  const _MyCarsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'profile.cars.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<MyCarsBloc, MyCarsState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.mutationStatus != current.mutationStatus,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.errorMessage != null && state.status.isFailure) {
            messenger.showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          if (state.mutationStatus == MyCarsMutationStatus.success &&
              state.mutationMessage != null) {
            messenger.showSnackBar(
              SnackBar(content: Text(state.mutationMessage!)),
            );
          } else if (state.mutationStatus == MyCarsMutationStatus.failure &&
              state.mutationMessage != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(state.mutationMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'profile.error_generic'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          if (state.cars.isEmpty) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_filled_outlined,
                      size: 64.sp,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      'profile.cars.empty_state.title'.tr(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextBody(
                      'profile.cars.empty_state.subtitle'.tr(),
                      textAlign: TextAlign.center,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 30.h),
                    CustomPrimaryButton(
                      text: 'profile.cars.add_button'.tr(),
                      onPressed: () => _openCarForm(context),
                    ),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  if (state.mutationStatus ==
                      MyCarsMutationStatus.inProgress) ...[
                    const LinearProgressIndicator(),
                    SizedBox(height: 12.h),
                  ],
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.cars.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final car = state.cars[index];
                        final isSelected = state.selectedCarId == car.id;
                        final userCar = state.findUserCar(car.id);

                        return MyCarCard(
                          car: car,
                          isSelected: isSelected,
                          onTap: () => context.read<MyCarsBloc>().add(
                            MyCarSelected(car.id),
                          ),
                          onLongPress: () {
                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24.r),
                                ),
                              ),
                              builder: (_) => MyCarActionsSheet(
                                onEdit: userCar == null
                                    ? null
                                    : () => _openCarForm(context, userCar),
                                onDelete: () {
                                  context.read<MyCarsBloc>().add(
                                    MyCarDeleted(car.id),
                                  );
                                },
                                onSetPrimary: car.isPrimary
                                    ? null
                                    : () => context.read<MyCarsBloc>().add(
                                        MyCarSetPrimary(car.id),
                                      ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomPrimaryButton(
                    text: 'profile.cars.add_button'.tr(),
                    onPressed: () => _openCarForm(context),
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

Future<void> _openCarForm(BuildContext context, [UserCar? car]) async {
  final result = await context.pushNamed<UserCar?>(
    RouteNames.addCar,
    extra: car,
  );
  if (result != null && context.mounted) {
    context.read<MyCarsBloc>().add(const MyCarsStarted(showLoader: false));
  }
}
