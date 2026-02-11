import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/profile_storage_service.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/extensions/l10n_context.dart';

/// Profile tab: user info and links to Edit profile and Settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile _profile = const UserProfile();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _profile = ProfileStorageService.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 32;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.profileDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileRow(
                    context,
                    l10n.height,
                    _profile.hasHeight
                        ? '${_profile.heightCm!.toStringAsFixed(0)} cm'
                        : l10n.notSet,
                  ),
                  const SizedBox(height: 12),
                  _profileRow(
                    context,
                    l10n.gender,
                    _profile.hasGender
                        ? (_profile.gender == 'male' ? l10n.male : l10n.female)
                        : l10n.notSet,
                  ),
                  if (_profile.hasBirthDate) ...[
                    const SizedBox(height: 12),
                    _profileRow(
                      context,
                      l10n.birthDate,
                      _formatDate(_profile.birthDate!),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: Text(l10n.editProfile),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                await context.push('/profile/edit');
                _loadProfile();
              },
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: Text(l10n.openSettings),
              subtitle: Text(l10n.openSettingsDesc),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
