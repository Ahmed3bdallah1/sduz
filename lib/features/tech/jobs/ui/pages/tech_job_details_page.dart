import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/core/dependecy_injection/di.dart';
import 'package:sudz/features/tech/jobs/bloc/bloc.dart';
import 'package:sudz/features/tech/jobs/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class TechJobDetailsPage extends StatelessWidget {
  final TechJob job;

  const TechJobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TechJobDetailsBloc>(param1: job)
            ..add(TechJobDetailsStarted(job)),
      child: const _TechJobDetailsView(),
    );
  }
}

class _TechJobDetailsView extends StatelessWidget {
  const _TechJobDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TechJobDetailsBloc, TechJobDetailsState>(
      listenWhen: (prev, curr) {
        final toastChanged =
            curr.toastKey != null && curr.toastKey != prev.toastKey;
        final geoWarningActivated =
            !prev.geoWarningActive && curr.geoWarningActive;
        return toastChanged || geoWarningActivated;
      },
      listener: (context, state) async {
        final bloc = context.read<TechJobDetailsBloc>();
        if (state.toastKey != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.toastKey!.tr(args: state.toastArgs ?? const []),
              ),
            ),
          );
          bloc.add(const TechJobToastCleared());
        }

        if (state.geoWarningActive) {
          final overrideNote = await _GeoWarningSheet.show(
            context,
            state.geoDistanceMeters,
          );
          if (overrideNote != null && overrideNote.trim().isNotEmpty) {
            bloc.add(TechJobArriveOverrideProvided(overrideNote.trim()));
          } else {
            bloc.add(const TechJobGeoWarningDismissed());
          }
        }
      },
      child: BlocBuilder<TechJobDetailsBloc, TechJobDetailsState>(
        builder: (context, state) {
          final theme = Theme.of(context);

          if (state.status.isInitial || state.status.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status.isFailure) {
            return Scaffold(
              appBar: AppBar(
                title: Text(tr('tech.jobs.details.title_default')),
              ),
              body: Center(
                child: Text(
                  state.errorMessage ?? tr('tech.jobs.details.error.generic'),
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                tr(
                  'tech.jobs.details.app_bar',
                  args: [state.job.referenceCode],
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 16.h,
                    bottom: 140.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatusHeader(job: state.job),
                      SizedBox(height: 16.h),
                      _OverviewCard(job: state.job),
                      SizedBox(height: 16.h),
                      _ClientCard(
                        job: state.job,
                        onCallPressed: () => _launchTel(context, state.job),
                      ),
                      SizedBox(height: 16.h),
                      _LocationCard(
                        job: state.job,
                        onNavigatePressed: () =>
                            _launchMaps(context, state.job),
                      ),
                      SizedBox(height: 16.h),
                      if (state.pendingActions.isNotEmpty) ...[
                        _PendingSyncCard(
                          pending: state.pendingActions,
                          isSyncing: state.isSyncing,
                          onSync: () => context.read<TechJobDetailsBloc>().add(
                            const TechJobSyncPendingRequested(),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      _EvidenceSection(
                        category: TechJobEvidenceCategory.preWork,
                        title: tr('tech.jobs.details.evidence.pre.title'),
                        requiredCount: state.job.preWorkPhotosRequired,
                        currentCount: state.preEvidenceCount,
                        evidence: state.preEvidence,
                        onAddPressed: () => context
                            .read<TechJobDetailsBloc>()
                            .add(const TechJobPreEvidenceAdded()),
                        onRemovePressed: (id) => context
                            .read<TechJobDetailsBloc>()
                            .add(TechJobEvidenceRemoved(id)),
                        helperText: tr(
                          'tech.jobs.details.evidence.pre.helper',
                          args: [state.job.preWorkPhotosRequired.toString()],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _EvidenceSection(
                        category: TechJobEvidenceCategory.postWork,
                        title: tr('tech.jobs.details.evidence.post.title'),
                        requiredCount: state.job.postWorkPhotosRequired,
                        currentCount: state.postEvidenceCount,
                        evidence: state.postEvidence,
                        onAddPressed: () => context
                            .read<TechJobDetailsBloc>()
                            .add(const TechJobPostEvidenceAdded()),
                        onRemovePressed: (id) => context
                            .read<TechJobDetailsBloc>()
                            .add(TechJobEvidenceRemoved(id)),
                        helperText: tr(
                          'tech.jobs.details.evidence.post.helper',
                          args: [state.job.postWorkPhotosRequired.toString()],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (state.rejectionEvidence.isNotEmpty) ...[
                        _EvidenceSection(
                          category: TechJobEvidenceCategory.rejection,
                          title: tr(
                            'tech.jobs.details.evidence.rejection.title',
                          ),
                          requiredCount: 0,
                          currentCount: state.rejectionEvidence.length,
                          evidence: state.rejectionEvidence,
                          onAddPressed: () => context
                              .read<TechJobDetailsBloc>()
                              .add(const TechJobRejectionEvidenceAdded()),
                          onRemovePressed: (id) => context
                              .read<TechJobDetailsBloc>()
                              .add(TechJobEvidenceRemoved(id)),
                          helperText: tr(
                            'tech.jobs.details.evidence.rejection.helper',
                          ),
                          allowRemove: true,
                        ),
                        SizedBox(height: 16.h),
                      ],
                      _TimelineSection(timeline: state.timeline),
                    ],
                  ),
                ),
                _ActionBar(
                  state: state,
                  onArrive: () => context.read<TechJobDetailsBloc>().add(
                    const TechJobArriveRequested(),
                  ),
                  onStartWork: () => context.read<TechJobDetailsBloc>().add(
                    const TechJobStartWorkRequested(),
                  ),
                  onComplete: () => context.read<TechJobDetailsBloc>().add(
                    const TechJobCompleteRequested(),
                  ),
                  onReject: () => _showRejectSheet(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showRejectSheet(BuildContext context) async {
    final reason = await _RejectJobSheet.show(context);
    if (!context.mounted) return;
    if (reason == null) return;
    context.read<TechJobDetailsBloc>().add(TechJobRejectRequested(reason));
  }

  Future<void> _launchMaps(BuildContext context, TechJob job) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${job.latitude},${job.longitude}',
    );
    await _launchExternal(
      context,
      uri,
      tr('tech.jobs.details.location.error_maps'),
    );
  }

  Future<void> _launchTel(BuildContext context, TechJob job) async {
    final sanitized = job.clientPhone.replaceAll(' ', '');
    final uri = Uri(scheme: 'tel', path: sanitized);
    await _launchExternal(
      context,
      uri,
      tr('tech.jobs.details.client.error_call', args: [job.clientPhone]),
    );
  }

  Future<void> _launchExternal(
    BuildContext context,
    Uri uri,
    String failureMessage,
  ) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && messenger != null) {
        messenger.showSnackBar(SnackBar(content: Text(failureMessage)));
      }
    } catch (_) {
      if (messenger != null) {
        messenger.showSnackBar(SnackBar(content: Text(failureMessage)));
      }
    }
  }
}

class _StatusHeader extends StatelessWidget {
  final TechJob job;

  const _StatusHeader({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = switch (job.status) {
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

    final chipColor = switch (job.status) {
      TechJobStatus.closed => Colors.green.shade50,
      TechJobStatus.rejected => Colors.red.shade50,
      TechJobStatus.cancelled => Colors.red.shade50,
      _ => theme.colorScheme.primary.withValues(alpha: 0.12),
    };

    final textColor = switch (job.status) {
      TechJobStatus.closed => Colors.green.shade800,
      TechJobStatus.rejected => Colors.red.shade700,
      TechJobStatus.cancelled => Colors.red.shade700,
      _ => theme.colorScheme.primary,
    };

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            statusLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        if (job.hasPendingSync)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sync, size: 18, color: Colors.orange.shade700),
                SizedBox(width: 6.w),
                Text(
                  tr('tech.jobs.details.badge.pending_sync'),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final TechJob job;

  const _OverviewCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, d MMM • hh:mm a');
    final schedule = job.scheduledEnd == null
        ? dateFormat.format(job.scheduledStart)
        : '${dateFormat.format(job.scheduledStart)} - ${DateFormat('hh:mm a').format(job.scheduledEnd!)}';

    return _SectionCard(
      title: tr('tech.jobs.details.sections.overview'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(job.serviceSummary, style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          _KeyValueRow(
            label: tr('tech.jobs.details.fields.request_id'),
            value: job.referenceCode,
          ),
          SizedBox(height: 4.h),
          _KeyValueRow(
            label: tr('tech.jobs.details.fields.window'),
            value: schedule,
          ),
          if (job.notes != null && job.notes!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              job.notes!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final TechJob job;
  final VoidCallback onCallPressed;

  const _ClientCard({required this.job, required this.onCallPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: tr('tech.jobs.details.sections.client'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(job.clientName, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              const Icon(Icons.phone_outlined),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(job.clientPhone, style: theme.textTheme.bodyMedium),
              ),
              TextButton.icon(
                onPressed: onCallPressed,
                icon: const Icon(Icons.call),
                label: Text(tr('tech.jobs.details.actions.call')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final TechJob job;
  final VoidCallback onNavigatePressed;

  const _LocationCard({required this.job, required this.onNavigatePressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: tr('tech.jobs.details.sections.location'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_outlined),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(job.addressLine, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: onNavigatePressed,
            icon: const Icon(Icons.navigation_outlined),
            label: Text(tr('tech.jobs.details.location.open_maps')),
          ),
        ],
      ),
    );
  }
}

class _PendingSyncCard extends StatelessWidget {
  final List<TechJobPendingAction> pending;
  final bool isSyncing;
  final VoidCallback onSync;

  const _PendingSyncCard({
    required this.pending,
    required this.isSyncing,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM • hh:mm a');

    return _SectionCard(
      title: tr('tech.jobs.details.sync.title'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('tech.jobs.details.sync.subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12.h),
          ...pending.map(
            (action) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pending_actions_outlined, size: 22),
              title: Text(tr(action.labelKey, args: action.labelArgs)),
              subtitle: Text(
                dateFormat.format(action.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton.icon(
            onPressed: isSyncing ? null : onSync,
            icon: isSyncing
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: Text(
              isSyncing
                  ? tr('tech.jobs.details.sync.in_progress')
                  : tr('tech.jobs.details.sync.action'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvidenceSection extends StatelessWidget {
  final TechJobEvidenceCategory category;
  final String title;
  final int requiredCount;
  final int currentCount;
  final List<TechJobEvidenceItem> evidence;
  final VoidCallback onAddPressed;
  final void Function(String id) onRemovePressed;
  final String helperText;
  final bool allowRemove;

  const _EvidenceSection({
    required this.category,
    required this.title,
    required this.requiredCount,
    required this.currentCount,
    required this.evidence,
    required this.onAddPressed,
    required this.onRemovePressed,
    required this.helperText,
    this.allowRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requirementText = requiredCount == 0
        ? tr('tech.jobs.details.evidence.optional')
        : tr(
            'tech.jobs.details.evidence.progress',
            args: [currentCount.toString(), requiredCount.toString()],
          );
    final isSatisfied = requiredCount == 0 || currentCount >= requiredCount;

    return _SectionCard(
      title: title,
      trailing: Chip(
        backgroundColor: isSatisfied
            ? Colors.green.shade50
            : theme.colorScheme.primary.withValues(alpha: 0.1),
        label: Text(
          requirementText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSatisfied
                ? Colors.green.shade700
                : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            helperText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              ...evidence.asMap().entries.map((entry) {
                final item = entry.value;
                final displayIndex = (entry.key + 1).toString();
                final label = switch (category) {
                  TechJobEvidenceCategory.preWork => tr(
                    'tech.jobs.details.evidence.labels.pre',
                    args: [displayIndex],
                  ),
                  TechJobEvidenceCategory.postWork => tr(
                    'tech.jobs.details.evidence.labels.post',
                    args: [displayIndex],
                  ),
                  TechJobEvidenceCategory.rejection => tr(
                    'tech.jobs.details.evidence.labels.rejection',
                    args: [displayIndex],
                  ),
                };

                return _EvidenceTile(
                  item: item,
                  label: label,
                  onRemovePressed: allowRemove
                      ? () => onRemovePressed(item.id)
                      : null,
                );
              }),
              _AddEvidenceButton(onPressed: onAddPressed),
            ],
          ),
        ],
      ),
    );
  }
}

class _EvidenceTile extends StatelessWidget {
  final TechJobEvidenceItem item;
  final String label;
  final VoidCallback? onRemovePressed;

  const _EvidenceTile({
    required this.item,
    required this.label,
    this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = item.category.isPre
        ? Icons.photo_camera_front_outlined
        : item.category.isPost
        ? Icons.photo_library_outlined
        : Icons.report_gmailerrorred_outlined;

    return Container(
      width: 110.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: theme.colorScheme.primary),
          SizedBox(height: 8.h),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (onRemovePressed != null) ...[
            SizedBox(height: 8.h),
            TextButton(
              onPressed: onRemovePressed,
              child: Text(tr('tech.jobs.details.evidence.remove')),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddEvidenceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddEvidenceButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_a_photo),
      label: Text(tr('tech.jobs.details.evidence.add_photo')),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  final List<TechJobTimelineEntry> timeline;

  const _TimelineSection({required this.timeline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM • hh:mm a');

    return _SectionCard(
      title: tr('tech.jobs.details.history.title'),
      child: Column(
        children: timeline.map((entry) {
          final title = tr(entry.titleKey, args: entry.titleArgs ?? const []);
          final note = entry.noteKey == null
              ? null
              : tr(entry.noteKey!, args: entry.noteArgs ?? const []);
          final subtitleParts = [dateFormat.format(entry.timestamp)];
          if (note != null && note.isNotEmpty) {
            subtitleParts.add(note);
          }

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.radio_button_checked, size: 20),
            title: Text(title),
            subtitle: Text(
              subtitleParts.join(' • '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final TechJobDetailsState state;
  final VoidCallback onArrive;
  final VoidCallback onStartWork;
  final VoidCallback onComplete;
  final VoidCallback onReject;

  const _ActionBar({
    required this.state,
    required this.onArrive,
    required this.onStartWork,
    required this.onComplete,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttons = <Widget>[];
    final arriveLabel = tr('tech.jobs.details.actions.arrive');
    final rejectLabel = tr('tech.jobs.details.actions.reject');
    final startLabel = tr('tech.jobs.details.actions.start_work');
    final completeLabel = tr('tech.jobs.details.actions.complete_work');

    Widget buildPrimaryButton(
      String label,
      VoidCallback onPressed,
      bool enabled, {
      bool showLoader = false,
    }) {
      return ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 48.h),
          backgroundColor: theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: showLoader
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      );
    }

    Widget buildSecondaryButton(
      String label,
      VoidCallback onPressed, {
      bool enabled = true,
    }) {
      return OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(label),
      );
    }

    final isLoadingAction = state.isActionInProgress;
    final disableActions = state.isActionInProgress || state.isSyncing;
    final activeAction = state.activeAction;

    switch (state.job.status) {
      case TechJobStatus.assigned:
      case TechJobStatus.enRoute:
        buttons.add(
          buildPrimaryButton(
            arriveLabel,
            onArrive,
            !disableActions,
            showLoader:
                isLoadingAction && activeAction == TechJobActionKind.arrive,
          ),
        );
        buttons.add(SizedBox(height: 12.h));
        // buttons.add(
        //   buildSecondaryButton(rejectLabel, onReject, enabled: !disableActions),
        // );
        break;
      case TechJobStatus.onSite:
        final canStart = state.hasEnoughPreEvidence && !disableActions;
        buttons.add(
          buildPrimaryButton(
            startLabel,
            onStartWork,
            canStart,
            showLoader:
                isLoadingAction && activeAction == TechJobActionKind.startWork,
          ),
        );
        if (!state.hasEnoughPreEvidence) {
          buttons.add(
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                tr(
                  'tech.jobs.details.validation.pre_evidence_required',
                  args: [state.job.preWorkPhotosRequired.toString()],
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          );
        }
        buttons.add(SizedBox(height: 12.h));
        buttons.add(
          buildSecondaryButton(rejectLabel, onReject, enabled: !disableActions),
        );
        break;
      case TechJobStatus.workStarted:
        final canComplete = state.hasEnoughPostEvidence && !disableActions;
        buttons.add(
          buildPrimaryButton(
            completeLabel,
            onComplete,
            canComplete,
            showLoader:
                isLoadingAction &&
                activeAction == TechJobActionKind.completeWork,
          ),
        );
        if (!state.hasEnoughPostEvidence) {
          buttons.add(
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                tr(
                  'tech.jobs.details.validation.post_evidence_required',
                  args: [state.job.postWorkPhotosRequired.toString()],
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          );
        }
        break;
      case TechJobStatus.pendingReview:
        buttons.add(
          Text(
            tr('tech.jobs.details.status.pending_review_message'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case TechJobStatus.workCompleted:
        buttons.add(
          Text(
            tr('tech.jobs.details.status.work_completed_message'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case TechJobStatus.closed:
        buttons.add(
          Text(
            tr('tech.jobs.details.status.closed_message'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case TechJobStatus.rejected:
        buttons.add(
          Text(
            tr('tech.jobs.details.status.rejected_message'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case TechJobStatus.cancelled:
        buttons.add(
          Text(
            tr('tech.jobs.details.status.cancelled_message'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: buttons),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140.w,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

class _GeoWarningSheet {
  static Future<String?> show(
    BuildContext context,
    double? distanceMeters,
  ) async {
    final controller = TextEditingController();
    final mediaQuery = MediaQuery.of(context);
    final distanceInfo = distanceMeters == null
        ? null
        : _formatDistance(distanceMeters);

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 24.h,
            bottom: mediaQuery.viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      tr('tech.jobs.details.geo.title'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                distanceInfo == null
                    ? tr('tech.jobs.details.geo.description_no_distance')
                    : tr(
                        'tech.jobs.details.geo.description',
                        args: [distanceInfo.$1, distanceInfo.$2],
                      ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: tr('tech.jobs.details.geo.override_label'),
                  hintText: tr('tech.jobs.details.geo.override_hint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(null),
                      child: Text(tr('tech.common.cancel')),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(sheetContext).pop(controller.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        tr('tech.jobs.details.geo.submit'),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
        );
      },
    );

    controller.dispose();
    return result;
  }

  static (String, String) _formatDistance(double meters) {
    if (meters >= 1000) {
      return ((meters / 1000).toStringAsFixed(2), 'km');
    }
    return (meters.toStringAsFixed(0), 'm');
  }
}

class _RejectJobSheet {
  static Future<String?> show(BuildContext context) async {
    final mediaQuery = MediaQuery.of(context);
    final controller = TextEditingController();
    final bloc = context.read<TechJobDetailsBloc>();

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: bloc,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 24.h,
              bottom: mediaQuery.viewInsets.bottom + 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('tech.jobs.details.reject.title'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 12.h),
                Text(
                  tr('tech.jobs.details.reject.description'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: tr('tech.jobs.details.reject.input_label'),
                  ),
                ),
                SizedBox(height: 16.h),
                BlocBuilder<TechJobDetailsBloc, TechJobDetailsState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: state.rejectionEvidence.asMap().entries.map(
                            (entry) {
                              final item = entry.value;
                              final label = tr(
                                'tech.jobs.details.evidence.labels.rejection',
                                args: [(entry.key + 1).toString()],
                              );
                              return _EvidenceTile(
                                item: item,
                                label: label,
                                onRemovePressed: () =>
                                    bloc.add(TechJobEvidenceRemoved(item.id)),
                              );
                            },
                          ).toList(),
                        ),
                        SizedBox(height: 12.h),
                        OutlinedButton.icon(
                          onPressed: () =>
                              bloc.add(const TechJobRejectionEvidenceAdded()),
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: Text(
                            tr('tech.jobs.details.reject.add_placeholder'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(null),
                        child: Text(tr('tech.common.cancel')),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(sheetContext).pop(controller.text),
                        child: Text(tr('tech.jobs.details.reject.submit')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
    return result;
  }
}
