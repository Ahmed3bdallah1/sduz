import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/core/routing/app_router.dart';

import 'core/dependecy_injection/di.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_state.dart';
import 'core/theme/widgets/theme_switch_button.dart';
import 'core/local_database/local_database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize local database
  final localDatabase = await LocalDatabaseService.instance;

  // Initialize dependency injection
  di.setup(localDatabase: localDatabase);
  // await di.getIt.allReady();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        // Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',

      fallbackLocale: const Locale('ar'),

      saveLocale: true,

      child: BlocProvider(
        create: (_) => ThemeBloc(localDatabase),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            // Update system UI overlay style based on theme
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: themeState.themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
                statusBarBrightness: themeState.themeMode == ThemeMode.dark
                    ? Brightness.dark
                    : Brightness.light,
                systemNavigationBarColor: themeState.themeMode == ThemeMode.dark
                    ? AppTheme.backgroundDark
                    : Colors.white,
                systemNavigationBarIconBrightness:
                    themeState.themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
              ),
            );

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'app_name'.tr(),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,

              themeMode: themeState.themeMode,

              // Localization delegates
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: Locale('ar'),

              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr()),
        actions: const [ThemeSwitchIconButton(), SizedBox(width: 8)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'welcome'.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                // Toggle language
                if (context.locale == const Locale('en')) {
                  context.setLocale(const Locale('ar'));
                } else {
                  context.setLocale(const Locale('en'));
                }
              },
              child: const Text('Change Language'),
            ),
            SizedBox(height: 30.h),
            const Divider(),
            SizedBox(height: 20.h),
            Text(
              'Theme Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20.h),
            // Simple switch
            const ThemeSwitchButton(showLabel: true),
            SizedBox(height: 30.h),
            // Animated toggle
            const AnimatedThemeSwitch(),
          ],
        ),
      ),
    );
  }
}
