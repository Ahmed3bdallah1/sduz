import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'package:sudz/core/network/auth_token_provider.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/auth/bloc/role_selection_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _carController;
  late final AnimationController _logoController;

  late final Animation<AlignmentGeometry> _carAlignment;
  late final Animation<double> _carScale;

  late final Animation<AlignmentGeometry> _logoAlignment;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _carController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    );

    _carAlignment =
        AlignmentTween(
          begin: const Alignment(1.2, 0.1),
          end: const Alignment(0, 0.85),
        ).animate(
          CurvedAnimation(parent: _carController, curve: Curves.easeOutCubic),
        );

    _carScale = Tween<double>(begin: 0.65, end: 1).animate(
      CurvedAnimation(parent: _carController, curve: Curves.easeOutBack),
    );

    _logoAlignment =
        AlignmentTween(
          begin: const Alignment(0, 0.9),
          end: const Alignment(0, -0.05),
        ).animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );

    _logoScale = Tween<double>(begin: 0.35, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );

    _carController.addStatusListener(_handleCarAnimationStatus);
    _logoController.addStatusListener(_handleLogoAnimationStatus);

    _carController.forward();
  }

  @override
  void dispose() {
    _carController.removeStatusListener(_handleCarAnimationStatus);
    _logoController.removeStatusListener(_handleLogoAnimationStatus);
    _carController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  void _handleCarAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _logoController.forward();
    }
  }

  Future<void> _handleLogoAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      final targetRoute = await _resolveInitialRoute();
      if (!mounted) return;
      context.goNamed(targetRoute);
    }
  }

  Future<String> _resolveInitialRoute() async {
    final tokenProvider = getIt<AuthTokenProvider>();
    final token = await tokenProvider.readAccessToken();
    if (token != null && token.isNotEmpty) {
      final database = getIt<LocalDatabaseService>();
      final storedRole = database.getUserRole();
      final role = RoleSelectionCubit.resolveStoredRole(storedRole);
      return role.isTechnical ? RouteNames.techHome : RouteNames.home;
    }
    return RouteNames.roleSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F3FF), Color(0xFFEDE7FF), Color(0xFF4C2A6D)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final carWidth = width * 0.78;
            final logoWidth = width * 0.68;

            return Padding(
              padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.06),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AlignTransition(
                    alignment: _logoAlignment,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Image.asset(
                          'assets/icons/Sudz__1__page-0001-removebg-preview (1) 1.png',
                          // 'assets/icons/view-3d-car-removebg-preview 1.png',
                          width: logoWidth,
                        ),
                      ),
                    ),
                  ),
                  // AlignTransition(
                  //   alignment: _carAlignment,
                  //   child: ScaleTransition(
                  //     scale: _carScale,
                  //     alignment: Alignment.bottomCenter,
                  //     child: Image.asset(
                  //       'assets/icons/view-3d-car-removebg-preview 1.png',
                  //       width: carWidth,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
