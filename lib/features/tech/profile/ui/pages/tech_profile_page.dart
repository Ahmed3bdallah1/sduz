import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TechProfilePage extends StatelessWidget {
  const TechProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adminPhone = tr('tech.profile.admin_phone');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('tech.profile.header.title'),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tr('tech.profile.header.subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24.h),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          tr('tech.profile.initials'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr('tech.profile.name'),
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              tr('tech.profile.role'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Divider(color: Colors.grey.shade200),
                  SizedBox(height: 16.h),
                  _ProfileInfoRow(
                    label: tr('tech.profile.app_name_label'),
                    value: tr('tech.profile.app_name_value'),
                  ),
                  SizedBox(height: 12.h),
                  _ProfileInfoRow(
                    label: tr('tech.profile.service_brand'),
                    value: tr('tech.profile.service_description'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            tr('tech.profile.contact_header'),
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            tr('tech.profile.contact_hint'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () => _callAdmin(adminPhone, context),
            icon: const Icon(Icons.call_outlined),
            label: Text(tr('tech.profile.call_admin')),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callAdmin(String phone, BuildContext context) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final sanitizedPhone = phone.replaceAll(' ', '');
    final uri = Uri(scheme: 'tel', path: sanitizedPhone);

    try {
      final launched = await launchUrl(uri);
      if (!launched) {
        messenger?.showSnackBar(
          SnackBar(content: Text(tr('tech.profile.call_error'))),
        );
      }
    } catch (_) {
      messenger?.showSnackBar(
        SnackBar(content: Text(tr('tech.profile.call_error'))),
      );
    }
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
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
