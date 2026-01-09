import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/car/domain/entities/user_car.dart';
import 'package:sudz/features/car/models/models.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import '../../../service/bloc/bloc.dart';
import '../../../service/schedule/models/models.dart';
import '../widgets/widgets.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key, this.initialServiceTypeId});

  final String? initialServiceTypeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ServiceBloc>()
        ..add(ServiceStarted(initialServiceTypeId: initialServiceTypeId)),
      child: const ServiceView(),
    );
  }
}

class ServiceView extends StatelessWidget {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'الغسيل',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color:
              theme.appBarTheme.titleTextStyle?.color ??
              theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        leadingWidth: 72.w,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(start: 16.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: BlocConsumer<ServiceBloc, ServiceState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.errorMessage != current.errorMessage,
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
          }
        },
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            final message = state.errorMessage ?? 'service.generic_error'.tr();
            return Center(
              child: CustomTextBody(message, color: theme.colorScheme.error),
            );
          }

          final bloc = context.read<ServiceBloc>();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.activePackage != null) ...[
                  ServiceActivePackageCard(
                    package: state.activePackage!,
                    onToggle: () => bloc.add(const ServicePackageToggled()),
                  ),
                  SizedBox(height: 24.h),
                ],
                ServiceCarSelectionSection(
                  cars: state.cars,
                  selectedCarId: state.selectedCarId,
                  onCarSelected: (car) {
                    bloc.add(ServiceCarSelected(car.id));
                  },
                  onAddCar: () async {
                    final newCar = await context.pushNamed<UserCar?>(
                      RouteNames.addCar,
                    );
                    if (newCar != null) {
                      bloc.add(ServiceCarAdded(ServiceCar.fromUserCar(newCar)));
                    }
                  },
                ),
                SizedBox(height: 24.h),
                ServiceTypeSection(
                  serviceTypes: state.serviceTypes,
                  selectedServiceTypeId: state.selectedServiceTypeId,
                  expandedServiceTypeIds: state.expandedServiceTypeIds,
                  onServiceSelected: (service) {
                    bloc.add(ServiceTypeSelected(service.id));
                  },
                  onServiceExpansionToggled: (service) {
                    bloc.add(ServiceTypeExpansionToggled(service.id));
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final selectedService = state.selectedServiceType;
          final hasCar = state.selectedCar != null;
          final canProceed = selectedService != null && hasCar;

          final buttonLabel = selectedService != null
              ? 'service.checkout.proceed_with_price'.tr(
                  args: ['${selectedService.price}', selectedService.currency],
                )
              : 'service.checkout.proceed_button'.tr();

          return Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: CustomButton(
              text: buttonLabel,
              onPressed: canProceed
                  ? () => _handleContinue(context, state)
                  : null,
              backgroundColor: theme.colorScheme.primary,
              textColor: theme.colorScheme.onPrimary,
              borderRadius: 16.r,
              fontSize: 15.sp,
            ),
          );
        },
      ),
    );
  }

  void _handleContinue(BuildContext context, ServiceState state) {
    final theme = Theme.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final selectedCar = state.selectedCar;
    if (selectedCar == null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: CustomTextBody(
              'service.checkout.error_select_car'.tr(),
              color: theme.colorScheme.onPrimary,
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      return;
    }

    final selectedService = state.selectedServiceType;
    if (selectedService == null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: CustomTextBody(
              'service.checkout.error_select_service'.tr(),
              color: theme.colorScheme.onPrimary,
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      return;
    }

    final params = ServiceScheduleParams(
      car: selectedCar,
      serviceType: selectedService,
      activePackage: state.activePackage,
    );

    context.pushNamed(RouteNames.serviceSchedule, extra: params);
  }
}
