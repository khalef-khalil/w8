import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../core/utils/weight_converter.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/widgets/education_overlay.dart';
import '../../../models/weight_entry.dart';

/// Max number of weekly medians to show (mobile data-density best practice).
const int _kMaxWeeksDisplayed = 16;

/// Chart height as fraction of viewport; clamped to [200, 280].
double _chartHeight(double viewportHeight) {
  return (viewportHeight * 0.35).clamp(200.0, 280.0);
}

/// Left axis reserved size; scales with width, clamped.
int _leftReserved(double width) {
  return (width * 0.14).clamp(40.0, 56.0).round();
}

/// Bottom axis reserved size.
int _bottomReserved(double width) {
  return (width < 360 ? 26 : 30).round();
}

/// Y-axis decimals: 1 on narrow screens, 2 otherwise.
int _yDecimals(double width) {
  return width < 360 ? 1 : 2;
}

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({
    super.key,
    required this.entries,
    this.initialWeight,
    this.targetWeight,
    this.unit = WeightUnit.kg,
    this.weekStartsOn = WeekStartDay.monday,
  });

  final List<WeightEntry> entries;
  final double? initialWeight;
  final double? targetWeight;
  final WeightUnit unit;
  final WeekStartDay weekStartsOn;

  @override
  Widget build(BuildContext context) {
    final weeklyMedians = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      weekStartsOn,
    );
    final displayed = weeklyMedians.length > _kMaxWeeksDisplayed
        ? weeklyMedians.sublist(weeklyMedians.length - _kMaxWeeksDisplayed)
        : weeklyMedians;

    if (displayed.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.show_chart_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.notEnoughData,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                context.l10n.addWeighInsForChart,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final size = MediaQuery.sizeOf(context);
    final chartHeight = _chartHeight(size.height);
    final leftReserved = _leftReserved(size.width);
    final bottomReserved = _bottomReserved(size.width);
    final yDecimals = _yDecimals(size.width);

    final minData =
        displayed.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxData =
        displayed.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final range = maxData - minData;
    final padding = range > 0 ? range * 0.2 : 1.0;

    double minY = minData - padding;
    double maxY = maxData + padding;
    if (initialWeight != null) {
      minY = math.min(minY, initialWeight!);
      maxY = math.max(maxY, initialWeight!);
    }
    if (targetWeight != null) {
      minY = math.min(minY, targetWeight!);
      maxY = math.max(maxY, targetWeight!);
    }
    final span = maxY - minY;
    minY -= span * 0.05;
    maxY += span * 0.05;
    final yInterval = (maxY - minY) / 5;

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final onSurfaceVariant =
        Theme.of(context).colorScheme.onSurfaceVariant;
    final surfaceVariant =
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final primary = Theme.of(context).colorScheme.primary;
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    final unitStr = unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;
    final horizontalLines = <HorizontalLine>[];
    if (targetWeight != null) {
      final targetDisplay =
          WeightConverter.forDisplay(targetWeight!, unit);
      horizontalLines.add(
        HorizontalLine(
          y: targetWeight!,
          color: primary.withValues(alpha: 0.6),
          strokeWidth: 1.5,
          dashArray: [4, 4],
          label: HorizontalLineLabel(
            show: true,
            labelResolver: (_) =>
                '${l10n.chartGoalLine} ${targetDisplay.toStringAsFixed(yDecimals)} $unitStr',
            style: (bodySmall ?? const TextStyle()).copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    if (initialWeight != null &&
        (targetWeight == null ||
            (initialWeight! - targetWeight!).abs() > 0.01)) {
      final initialDisplay =
          WeightConverter.forDisplay(initialWeight!, unit);
      horizontalLines.add(
        HorizontalLine(
          y: initialWeight!,
          color: surfaceVariant,
          strokeWidth: 1,
          dashArray: [2, 4],
          label: HorizontalLineLabel(
            show: true,
            labelResolver: (_) =>
                '${l10n.chartStartLine} ${initialDisplay.toStringAsFixed(yDecimals)} $unitStr',
            style: (bodySmall ?? const TextStyle())
                .copyWith(color: onSurfaceVariant),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.weeklyEvolution,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                EducationButton(
                  contentId: 'weekly_medians',
                  tooltip: context.l10n.learnMore,
                  child: Icon(
                    Icons.help_outline_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: chartHeight,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yInterval,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: surfaceVariant,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: bottomReserved.toDouble(),
                        interval: displayed.length > 8 ? 2 : 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < displayed.length) {
                            final date = displayed[index].key;
                            return Text(
                              DateFormat('dd/MM', locale).format(date),
                              style: bodySmall?.copyWith(
                                color: onSurfaceVariant,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: leftReserved.toDouble(),
                        interval: yInterval,
                        getTitlesWidget: (value, meta) {
                          final display =
                              WeightConverter.forDisplay(value, unit);
                          return Text(
                            display.toStringAsFixed(yDecimals),
                            style: bodySmall?.copyWith(
                              color: onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: surfaceVariant),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: horizontalLines,
                    extraLinesOnTop: false,
                  ),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    longPressDuration: const Duration(milliseconds: 150),
                    touchSpotThreshold: 12,
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      maxContentWidth: 120,
                      tooltipBgColor: primary,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      getTooltipItems: (touchedSpots) {
                        final style = (bodySmall ?? const TextStyle()).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        );
                        return touchedSpots.map((s) {
                          final i = s.spotIndex;
                          if (i < 0 || i >= displayed.length) {
                            return null;
                          }
                          final e = displayed[i];
                          final dateStr =
                              DateFormat('dd/MM/yy', locale).format(e.key);
                          final display =
                              WeightConverter.forDisplay(e.value, unit);
                          final valueStr =
                              '${display.toStringAsFixed(2)} $unitStr';
                          return LineTooltipItem(
                            '$dateStr\n$valueStr',
                            style,
                          );
                        }).whereType<LineTooltipItem>().toList();
                      },
                    ),
                  ),
                  minX: 0,
                  maxX: (displayed.length - 1).toDouble(),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: displayed
                          .asMap()
                          .entries
                          .map((e) =>
                              FlSpot(e.key.toDouble(), e.value.value))
                          .toList(),
                      isCurved: true,
                      color: primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
