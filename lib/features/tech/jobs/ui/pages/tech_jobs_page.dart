import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/core/routing/route_names.dart';
import 'package:sudz/features/tech/jobs/bloc/bloc.dart';
import 'package:sudz/features/tech/jobs/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class TechJobsPage extends StatelessWidget {
  const TechJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TechJobsBloc>()..add(const TechJobsStarted()),
      child: const _TechJobsView(),
    );
  }
}

class _TechJobsView extends StatelessWidget {
  const _TechJobsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TechJobsBloc, TechJobsState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status.isFailure) {
          return _TechJobsError(
            message: state.errorMessage ?? tr('tech.jobs.list.error.generic'),
            onRetry: () {
              context.read<TechJobsBloc>().add(const TechJobsStarted());
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<TechJobsBloc>().add(const TechJobsRefreshed());
            await Future<void>.delayed(const Duration(milliseconds: 400));
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            children: [
              _JobsFilterRow(
                selected: state.filter,
                onSelected: (filter) {
                  context.read<TechJobsBloc>().add(
                    TechJobsFilterChanged(filter),
                  );
                },
              ),
              SizedBox(height: 16.h),
              if (state.visibleJobs.isEmpty)
                const _TechJobsEmpty()
              else
                ...state.visibleJobs.map(
                  (job) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _TechJobCard(job: job),
                  ),
                ),
              if (state.isSyncing) ...[
                SizedBox(height: 12.h),
                const _SyncingBanner(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _JobsFilterRow extends StatelessWidget {
  final TechJobFilterTag selected;
  final ValueChanged<TechJobFilterTag> onSelected;

  const _JobsFilterRow({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: TechJobFilterTag.values.map((filter) {
        final isSelected = selected == filter;
        return ChoiceChip(
          label: Text(tr('tech.jobs.filters.${filter.name}')),
          selected: isSelected,
          onSelected: (_) => onSelected(filter),
          selectedColor: theme.colorScheme.primary.withValues(alpha: 0.16),
          backgroundColor: theme.colorScheme.surface,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.grey.shade300,
            ),
          ),
          labelStyle: TextStyle(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        );
      }).toList(),
    );
  }
}

class _TechJobCard extends StatelessWidget {
  final TechJob job;

  const _TechJobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, d MMM • hh:mm a');
    final windowText = job.scheduledEnd == null
        ? dateFormat.format(job.scheduledStart)
        : '${dateFormat.format(job.scheduledStart)} - ${DateFormat('hh:mm a').format(job.scheduledEnd!)}';
    final distanceText = _buildDistanceText(context);

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => _openDetails(context),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.serviceSummary,
                          style: theme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          tr(
                            'tech.jobs.list.request_code',
                            args: [job.referenceCode],
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.location_on_outlined),
                        color: theme.colorScheme.primary,
                        tooltip: tr('tech.jobs.list.actions.open_maps'),
                        onPressed: () => _openMaps(context),
                      ),
                      SizedBox(height: 8.h),
                      _StatusBadge(status: job.status),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _InfoRow(icon: Icons.person_outline, text: job.clientName),
              SizedBox(height: 8.h),
              _InfoRow(icon: Icons.schedule_outlined, text: windowText),
              SizedBox(height: 8.h),
              _InfoRow(icon: Icons.place_outlined, text: job.addressLine),
              if (distanceText != null) ...[
                SizedBox(height: 8.h),
                _InfoRow(
                  icon: Icons.directions_car_outlined,
                  text: distanceText,
                ),
              ],
              if (job.hasPendingSync) ...[
                SizedBox(height: 8.h),
                _InfoRow(
                  icon: Icons.sync_problem,
                  iconColor: Colors.orange.shade700,
                  text: tr('tech.jobs.list.pending_sync'),
                  textStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _openDetails(context),
                      style: ElevatedButton.styleFrom(
                        // padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        tr('tech.jobs.list.view_details'),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _buildDistanceText(BuildContext context) {
    final parts = <String>[];
    final distance = job.distanceKm;
    if (distance != null) {
      parts.add(
        tr(
          'tech.jobs.list.distance.kilometers',
          args: [distance.toStringAsFixed(1)],
        ),
      );
    }
    if (job.eta != null) {
      final minutes = job.eta!.inMinutes;
      if (minutes >= 60) {
        final hours = minutes ~/ 60;
        final remaining = minutes % 60;
        if (remaining == 0) {
          parts.add(
            tr('tech.jobs.list.distance.eta_hours', args: [hours.toString()]),
          );
        } else {
          parts.add(
            tr(
              'tech.jobs.list.distance.eta_hours_minutes',
              args: [hours.toString(), remaining.toString()],
            ),
          );
        }
      } else {
        parts.add(
          tr('tech.jobs.list.distance.eta_minutes', args: [minutes.toString()]),
        );
      }
    }

    if (parts.isEmpty) return null;
    return parts.join(' • ');
  }

  Future<void> _openMaps(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${job.latitude},${job.longitude}',
    );

    final messenger = ScaffoldMessenger.maybeOf(context);
    final errorText = tr('tech.jobs.list.error.maps');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        messenger?.showSnackBar(SnackBar(content: Text(errorText)));
      }
    } catch (_) {
      messenger?.showSnackBar(SnackBar(content: Text(errorText)));
    }
  }

  void _openDetails(BuildContext context) {
    context.pushNamed(RouteNames.techJobDetails, extra: job);
  }
}

class _StatusBadge extends StatelessWidget {
  final TechJobStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = switch (status) {
      TechJobStatus.assigned => tr('tech.jobs.status.assigned'),
      TechJobStatus.enRoute => tr('tech.jobs.status.en_route'),
      TechJobStatus.onSite => tr('tech.jobs.status.on_site'),
      TechJobStatus.workStarted => tr('tech.jobs.status.work_started'),
      TechJobStatus.workCompleted => tr('tech.jobs.status.work_completed'),
      TechJobStatus.pendingReview => tr('tech.jobs.status.pending_review'),
      TechJobStatus.closed => tr('tech.jobs.status.closed'),
      TechJobStatus.rejected => tr('tech.jobs.status.rejected'),
      TechJobStatus.cancelled => tr('tech.jobs.status.cancelled'),
    };

    final background = switch (status) {
      TechJobStatus.closed => Colors.green.shade50,
      TechJobStatus.rejected => Colors.red.shade50,
      TechJobStatus.cancelled => Colors.red.shade50,
      _ => colorScheme.primary.withValues(alpha: 0.08),
    };

    final foreground = switch (status) {
      TechJobStatus.closed => Colors.green.shade700,
      TechJobStatus.rejected => Colors.red.shade700,
      TechJobStatus.cancelled => Colors.red.shade700,
      _ => colorScheme.primary,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final TextStyle? textStyle;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.iconColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor ?? theme.iconTheme.color),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(text, style: textStyle ?? theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _TechJobsEmpty extends StatelessWidget {
  const _TechJobsEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 48.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.work_outline_rounded, size: 48),
          SizedBox(height: 12.h),
          Text(
            tr('tech.jobs.list.empty.title'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            tr('tech.jobs.list.empty.subtitle'),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _TechJobsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TechJobsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48),
          SizedBox(height: 12.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(tr('tech.jobs.list.actions.retry')),
          ),
        ],
      ),
    );
  }
}

class _SyncingBanner extends StatelessWidget {
  const _SyncingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync, color: Colors.orange),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              tr('tech.jobs.list.syncing_banner'),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
