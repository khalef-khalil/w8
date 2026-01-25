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
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_boundary.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/models/weight_entry_tags.dart';
import '../../../models/weight_entry.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  static const int _itemsPerPage = 20;
  int _displayedCount = _itemsPerPage;

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      data: (state) {
        final entries = state.entries.reversed.toList();
        final displayedEntries = entries.take(_displayedCount).toList();
        final hasMore = entries.length > _displayedCount;

        return RefreshIndicator(
          onRefresh: () {
            setState(() => _displayedCount = _itemsPerPage);
            return ref.read(homeViewModelProvider.notifier).refresh();
          },
          child: entries.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: NoHistoryEmptyState(
                    onAddWeight: () => context.go('/add-weight'),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: displayedEntries.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == displayedEntries.length) {
                      // Load more button
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _displayedCount += _itemsPerPage;
                              });
                            },
                            child: Text(context.l10n.loadMore),
                          ),
                        ),
                      );
                    }
                    final entry = displayedEntries[index];
                    return _WeighInTileWithContext(
                      entry: entry,
                      unit: state.goalConfig?.unit ?? WeightUnit.kg,
                      onEdit: () => context.push(
                        '/add-weight',
                        extra: entry,
                      ),
                      onDelete: () => _confirmDelete(context, ref, entry),
                    );
                  },
                ),
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SkeletonCard(),
        ),
      ),
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
  
  try {
    await HiveStorageService.deleteWeightEntry(entry.date); // entry.date is already a full DateTime
    ref.read(homeViewModelProvider.notifier).refresh();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: DefaultTextStyle(
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          child: Text(l10n.entryDeleted),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  } catch (e, stackTrace) {
    if (context.mounted) {
      ErrorHandler.handleError(
        context,
        e,
        stackTrace: stackTrace,
        message: l10n.errorDeleting,
      );
    }
  }
}

class _WeighInTileWithContext extends StatelessWidget {
  const _WeighInTileWithContext({
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
    } else {
      dateLabel =
          DateFormat('EEEE d MMMM', locale).format(entry.date);
    }

    final tags = entry.tags;
    final hasContext = tags != null && !tags.isEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
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
        title: Text(
          dateLabel,
          style:
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('HH:mm', locale).format(entry.date),
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
            ),
            if (hasContext) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (tags!.sleepQuality != null)
                    Chip(
                      label: Text('😴 ${tags.sleepQualityLabel}'),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (tags.stressLevel != null)
                    Chip(
                      label: Text('😰 ${tags.stressLevelLabel}'),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  if (tags.exercised == true)
                    Chip(
                      label: Text('💪 ${context.l10n.exercisedToday}'),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(
                '${display.toStringAsFixed(2)} $unitStr',
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
              ),
            ),
            PopupMenuButton<String>(
              iconSize: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(context.l10n.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(context.l10n.delete),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        children: hasContext ? [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tags!.mealTiming != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tags.mealTimingLabel ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                if (tags.notes != null && tags.notes!.isNotEmpty) ...[
                  Text(
                    context.l10n.notes,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tags.notes!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ] : [],
      ),
    );
  }
}
