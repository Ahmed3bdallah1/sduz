import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/shared/widgets/widgets.dart';
import '../../bloc/bloc.dart';
import '../widgets/widgets.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersBloc>()..add(const OrdersStarted()),
      child: const OrdersView(),
    );
  }
}

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: CustomText(
          'الحجوزات',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color:
              theme.appBarTheme.titleTextStyle?.color ??
              theme.colorScheme.onSurface,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(RouteNames.home);
            }
          },
        ),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'حدث خطأ غير متوقع',
                color: theme.colorScheme.error,
              ),
            );
          }

          final bloc = context.read<OrdersBloc>();
          final orders = state.currentOrders;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                OrdersSegmentedControl(
                  selectedSegment: state.segment,
                  onSegmentChanged: (segment) =>
                      bloc.add(OrdersSegmentChanged(segment)),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      return OrdersBookingCard(booking: orders[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: AppBottomNavigationBar(
      //   currentIndex: 1,
      //   onItemSelected: (index) {
      //     final router = GoRouter.of(context);
      //     switch (index) {
      //       case 0:
      //         router.goNamed(RouteNames.home);
      //         break;
      //       case 1:
      //         break;
      //       case 2:
      //         router.goNamed(RouteNames.store);
      //         break;
      //       case 3:
      //         break;
      //     }
      //   },
      // ),
    );
  }
}
