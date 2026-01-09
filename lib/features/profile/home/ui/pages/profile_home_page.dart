import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/local_database/local_database_service.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/core/theme/app_theme.dart';
import 'package:sudz/features/profile/home/bloc/bloc.dart';
import 'package:sudz/features/profile/shared/models/models.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class ProfileHomePage extends StatelessWidget {
  const ProfileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileHomeBloc>()..add(const ProfileHomeStarted()),
      child: const _ProfileHomeScaffold(),
    );
  }
}

class _ProfileHomeScaffold extends StatelessWidget {
  const _ProfileHomeScaffold();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          'profile.title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: const ProfileHomeBody(showHeaderBackIcon: true),
    );
  }
}

class ProfileHomeBody extends StatelessWidget {
  final bool showHeaderBackIcon;

  const ProfileHomeBody({super.key, this.showHeaderBackIcon = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileHomeBloc, ProfileHomeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

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

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: SafeArea(
            child: Column(
              children: [
                _ProfileHeader(
                  name: state.userName,
                  showLeading: showHeaderBackIcon,
                ),
                SizedBox(height: 20.h),
                _QuickLinksSection(
                  quickLinks: state.quickLinks,
                  selectedLanguage: state.selectedLanguageCode,
                  onLanguageToggle: (code) => context
                      .read<ProfileHomeBloc>()
                      .add(ProfileLanguageToggled(code)),
                ),
                SizedBox(height: 16.h),
                _PolicySection(policies: state.policies),
                SizedBox(height: 16.h),
                const _LogoutSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final bool showLeading;

  const _ProfileHeader({required this.name, this.showLeading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          // if (showLeading)
          //   Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18.sp),
          // if (showLeading) SizedBox(width: 8.w),
          CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.white,
            child: Icon(
              CupertinoIcons.person,
              color: Colors.black,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          CustomText(
            name,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _QuickLinksSection extends StatelessWidget {
  final List<ProfileQuickLink> quickLinks;
  final String selectedLanguage;
  final ValueChanged<String> onLanguageToggle;

  const _QuickLinksSection({
    required this.quickLinks,
    required this.selectedLanguage,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ...quickLinks.map((item) {
            if (item.id == 'language') {
              return _LanguageRow(
                isEnglish: selectedLanguage == 'en',
                onToggle: () =>
                    onLanguageToggle(selectedLanguage == 'en' ? 'ar' : 'en'),
              );
            }

            return _ProfileRow(
              title: item.titleKey.tr(),
              iconAsset: item.iconAsset,
              onTap: () => _onQuickLinkTap(context, item.id),
            );
          }),
        ],
      ),
    );
  }

  void _onQuickLinkTap(BuildContext context, String id) async {
    // Check authentication for cars and packages
    if (id == 'cars' || id == 'packages') {
      final localDb = await LocalDatabaseService.instance;
      final token = localDb.getToken();

      if (token == null || token.isEmpty) {
        if (!context.mounted) return;
        _showLoginRequiredDialog(context);
        return;
      }
    }

    // Navigate to the respective page
    if (!context.mounted) return;
    switch (id) {
      case 'cars':
        context.push(RouteNames.profileCars);
        break;
      case 'packages':
        context.push(RouteNames.profilePackages);
        break;
      case 'gifts':
        context.push(RouteNames.profileDedication);
        break;
      default:
        break;
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          'common.login_required_title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        content: CustomTextBody('common.login_required_message'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CustomTextBody('common.cancel'.tr(), color: Colors.grey),
          ),
          CustomButton(
            text: 'common.login_button'.tr(),
            onPressed: () {
              Navigator.of(context).pop();
              context.push(RouteNames.login);
            },
            backgroundColor: AppTheme.primaryLight,
            textColor: Colors.white,
            height: 40,
            borderRadius: 8,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final List<ProfilePolicyItem> policies;

  const _PolicySection({required this.policies});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: policies
            .map(
              (item) => _ProfileRow(
                title: item.titleKey.tr(),
                iconAsset: item.iconAsset,
                onTap: () {},
              ),
            )
            .toList(),
      ),
    );
  }
}

class _LogoutSection extends StatelessWidget {
  const _LogoutSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<LocalDatabaseService>(
      future: LocalDatabaseService.instance,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final localDb = snapshot.data!;
        final token = localDb.getToken();
        final isLoggedIn = token != null && token.isNotEmpty;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: _ProfileRow(
            title: isLoggedIn
                ? 'profile.logout'.tr()
                : 'common.login_button'.tr(),
            iconAsset: 'assets/icons/Logout.svg',
            titleColor: isLoggedIn
                ? const Color(0xFFE74C3C)
                : AppTheme.primaryLight,
            onTap: () async {
              if (isLoggedIn) {
                await _handleLogout(context, localDb);
              } else {
                context.push(RouteNames.login);
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    LocalDatabaseService localDb,
  ) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          'profile.logout_confirm_title'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        content: CustomTextBody('profile.logout_confirm_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: CustomTextBody('common.cancel'.tr(), color: Colors.grey),
          ),
          CustomButton(
            text: 'profile.logout'.tr(),
            onPressed: () => Navigator.of(context).pop(true),
            backgroundColor: const Color(0xFFE74C3C),
            textColor: Colors.white,
            height: 40,
            borderRadius: 8,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;
    if (!context.mounted) return;

    // Clear token and user data
    await localDb.clearToken();
    await localDb.setLoggedIn(false);

    if (!context.mounted) return;

    // Navigate to login page
    context.go(RouteNames.login);
  }
}

class _ProfileRow extends StatelessWidget {
  final String title;
  final String iconAsset;
  final VoidCallback onTap;
  final Color? titleColor;

  const _ProfileRow({
    required this.title,
    required this.iconAsset,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            iconAsset.isEmpty
                ? SizedBox.shrink()
                : SvgPicture.asset(
                    iconAsset,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: ColorFilter.mode(
                      titleColor ?? const Color(0xFFB5AEC2),
                      BlendMode.srcIn,
                    ),
                  ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                title,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: titleColor ?? theme.colorScheme.onSurface,
                textAlign: TextAlign.right,
              ),
            ),
            // SizedBox(width: 12.w),
            // SvgPicture.asset(
            //   iconAsset,
            //   width: 24.w,
            //   height: 24.w,
            //   colorFilter: ColorFilter.mode(
            //     titleColor ?? const Color(0xFFB5AEC2),
            //     BlendMode.srcIn,
            //   ),
            // ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFFCBCBD4)),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback onToggle;

  const _LanguageRow({required this.isEnglish, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // const Icon(Icons.chevron_left, color: Color(0xFFCBCBD4)),
          // Image.asset('assets/icons/Iconly/Two-tone/Logout.svg'),
          SvgPicture.asset(
            'assets/icons/language 1.svg',
            width: 24.w,
            height: 24.w,
            colorFilter: ColorFilter.mode(
              const Color(0xFFB5AEC2),
              BlendMode.srcIn,
            ),
            // colorFilter: ColorFilter.mode(
            //   // const Color(0xFFB5AEC2),
            //   BlendMode.srcIn,
            // ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              'profile.quick_links.language'.tr(),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.right,
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E7ED),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: CustomText(
                      isEnglish ? 'e' : 'ع',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CustomTextBody(
                    isEnglish
                        ? 'profile.language.en'.tr()
                        : 'profile.language.ar'.tr(),
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
