import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudz/core/theme/bloc/theme_bloc.dart';
import 'package:sudz/core/theme/bloc/theme_event.dart';
import 'package:sudz/core/theme/bloc/theme_state.dart';

class ThemeSwitchButton extends StatelessWidget {
  final bool showLabel;
  final EdgeInsetsGeometry? padding;

  const ThemeSwitchButton({
    super.key,
    this.showLabel = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: showLabel
              ? SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: Text(isDark ? 'Enabled' : 'Disabled'),
                  value: isDark,
                  onChanged: (_) {
                    context.read<ThemeBloc>().add(const ToggleThemeEvent());
                  },
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                )
              : Switch(
                  value: isDark,
                  onChanged: (_) {
                    context.read<ThemeBloc>().add(const ToggleThemeEvent());
                  },
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.dark_mode);
                      }
                      return const Icon(Icons.light_mode);
                    },
                  ),
                ),
        );
      },
    );
  }
}

// Icon button version for app bar
class ThemeSwitchIconButton extends StatelessWidget {
  const ThemeSwitchIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
          ),
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          onPressed: () {
            context.read<ThemeBloc>().add(const ToggleThemeEvent());
          },
        );
      },
    );
  }
}

// Animated toggle button
class AnimatedThemeSwitch extends StatelessWidget {
  const AnimatedThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeButton(
                context: context,
                icon: Icons.light_mode,
                label: 'Light',
                isSelected: !isDark,
                onTap: () {
                  if (isDark) {
                    context
                        .read<ThemeBloc>()
                        .add(const SetThemeEvent(AppThemeMode.light));
                  }
                },
              ),
              _buildThemeButton(
                context: context,
                icon: Icons.dark_mode,
                label: 'Dark',
                isSelected: isDark,
                onTap: () {
                  if (!isDark) {
                    context
                        .read<ThemeBloc>()
                        .add(const SetThemeEvent(AppThemeMode.dark));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
