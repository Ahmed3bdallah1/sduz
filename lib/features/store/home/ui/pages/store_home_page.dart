import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/store/home/bloc/bloc.dart';
import 'package:sudz/features/store/shared/ui/widgets/widgets.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class StoreHomePage extends StatelessWidget {
  const StoreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoreHomeBloc>()..add(const StoreHomeStarted()),
      child: const _StoreHomeView(),
    );
  }
}

class _StoreHomeView extends StatelessWidget {
  const _StoreHomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          'store.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.storeCart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: BlocBuilder<StoreHomeBloc, StoreHomeState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status.isFailure) {
            return Center(
              child: CustomTextBody(
                state.errorMessage ?? 'store.error_generic'.tr(),
                color: theme.colorScheme.error,
              ),
            );
          }

          final categories = state.categories;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return StoreCategoryCard(
                  category: category,
                  onTap: () {
                    context.pushNamed(
                      RouteNames.storeCategory,
                      extra: category,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 2,
        onItemSelected: (index) {
          final router = GoRouter.of(context);
          switch (index) {
            case 0:
              router.goNamed(RouteNames.home);
              break;
            case 1:
              router.goNamed(RouteNames.orders);
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}
