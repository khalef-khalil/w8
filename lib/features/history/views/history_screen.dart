import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../core/extensions/l10n_context.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/utils/weight_converter.dart';
import '../../../models/weight_entry.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      data: (state) {
        final entries = state.entries.reversed.toList();
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(homeViewModelProvider.notifier).refresh(),
          child: entries.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.addFirstWeighIn,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => context.go('/add-weight'),
                            icon: const Icon(Icons.add),
                            label: Text(context.l10n.addWeight),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      for (final entry in entries)
                        _WeighInTile(
                          entry: entry,
                          unit: state.goalConfig?.unit ?? WeightUnit.kg,
                          onEdit: () => context.push(
                            '/add-weight',
                            extra: entry,
                          ),
                          onDelete: () => _confirmDelete(context, ref, entry),
                        ),
                    ],
                  ),
                ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.errorLoading),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(homeViewModelProvider.notifier).refresh(),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  WeightEntry entry,
) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.deleteEntryTitle),
      content: Text(l10n.deleteEntryMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await HiveStorageService.deleteWeightEntry(entry.date); // entry.date is already a full DateTime
  ref.read(homeViewModelProvider.notifier).refresh();
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.entryDeleted),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

class _WeighInTile extends StatelessWidget {
  const _WeighInTile({
    required this.entry,
    required this.unit,
    required this.onEdit,
    required this.onDelete,
  });

  final WeightEntry entry;
  final WeightUnit unit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isToday = date_utils.AppDateUtils.isSameDay(
        entry.date, DateTime.now());
    final isYesterday = date_utils.AppDateUtils.isSameDay(
      entry.date,
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final locale =
        Localizations.localeOf(context).toString();
    final unitStr = unit == WeightUnit.lbs
        ? context.l10n.lbsUnit
        : context.l10n.kgUnit;
    final display =
        WeightConverter.forDisplay(entry.weight, unit);

    String dateLabel;
    if (isToday) {
      dateLabel = context.l10n.today;
    } else if (isYesterday) {
      dateLabel = context.l10n.yesterday;
    } else {
      dateLabel =
          DateFormat('EEEE d MMMM', locale).format(entry.date);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.scale_rounded,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateLabel,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  DateFormat('HH:mm', locale).format(entry.date),
                  style:
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            '${display.toStringAsFixed(2)} $unitStr',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEdit,
            tooltip: context.l10n.edit,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: onDelete,
            tooltip: context.l10n.delete,
          ),
        ],
      ),
    );
  }
}
