import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/tech/home/bloc/bloc.dart';
import 'package:sudz/features/tech/jobs/ui/pages/pages.dart';
import 'package:sudz/features/tech/profile/ui/pages/pages.dart';

class TechHomePage extends StatelessWidget {
  const TechHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TechHomeBloc>()..add(const TechHomeStarted()),
      child: const _TechHomeView(),
    );
  }
}

class _TechHomeView extends StatelessWidget {
  const _TechHomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechHomeBloc, TechHomeState>(
      builder: (context, state) {
        final tab = state.currentTab;

        return Scaffold(
          appBar: AppBar(
            title: Text(_mapTabToTitle(context, tab)),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () => context.go(RouteNames.roleSelection),
                icon: const Icon(Icons.exit_to_app_outlined),
                tooltip: tr('tech.home.nav.switch_role'),
              ),
            ],
          ),
          body: IndexedStack(
            index: state.bottomNavIndex,
            children: const [TechJobsPage(), TechProfilePage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.bottomNavIndex,
            onTap: (index) {
              context.read<TechHomeBloc>().add(TechHomeBottomNavChanged(index));
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.work_outline_rounded),
                activeIcon: const Icon(Icons.work_rounded),
                label: tr('tech.home.nav.jobs'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: tr('tech.home.nav.profile'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _mapTabToTitle(BuildContext context, TechHomeTab tab) => switch (tab) {
    TechHomeTab.jobs => tr('tech.home.title.jobs'),
    TechHomeTab.profile => tr('tech.home.title.profile'),
  };
}
