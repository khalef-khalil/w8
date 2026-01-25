import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../core/utils/weight_converter.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/models/chart_time_range.dart';
import '../../../core/widgets/education_overlay.dart';
import '../../../models/weight_entry.dart';

/// Max number of weekly medians to show (mobile data-density best practice).
const int _kMaxWeeksDisplayed = 16;

/// Chart zoom state
class _ChartZoomState {
  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;
  bool isZoomed = false;
}

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

class WeeklyChartCard extends StatefulWidget {
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
  State<WeeklyChartCard> createState() => _WeeklyChartCardState();
}

class _WeeklyChartCardState extends State<WeeklyChartCard> {
  ChartTimeRange _selectedTimeRange = ChartTimeRange.all;
  _ChartZoomState? _zoomState;

  @override
  Widget build(BuildContext context) {
    final weeklyMedians = date_utils.AppDateUtils.getWeeklyMedians(
      widget.entries,
      widget.weekStartsOn,
    );
    
    // Filter by time range
    final filteredMedians = _filterByTimeRange(weeklyMedians);
    
    // Apply zoom if active, otherwise use default display logic
    final displayed = _zoomState?.isZoomed == true
        ? _getZoomedData(filteredMedians)
        : (filteredMedians.length > _kMaxWeeksDisplayed
            ? filteredMedians.sublist(filteredMedians.length - _kMaxWeeksDisplayed)
            : filteredMedians);

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

    double minY = _zoomState?.isZoomed == true ? _zoomState!.minY : (minData - padding);
    double maxY = _zoomState?.isZoomed == true ? _zoomState!.maxY : (maxData + padding);
    
    if (!(_zoomState?.isZoomed == true)) {
      if (widget.initialWeight != null) {
        minY = math.min(minY, widget.initialWeight!);
        maxY = math.max(maxY, widget.initialWeight!);
      }
      if (widget.targetWeight != null) {
        minY = math.min(minY, widget.targetWeight!);
        maxY = math.max(maxY, widget.targetWeight!);
      }
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

    final unitStr = widget.unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;
    final horizontalLines = <HorizontalLine>[];
    if (widget.targetWeight != null) {
      final targetDisplay =
          WeightConverter.forDisplay(widget.targetWeight!, widget.unit);
      horizontalLines.add(
        HorizontalLine(
          y: widget.targetWeight!,
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
    if (widget.initialWeight != null &&
        (widget.targetWeight == null ||
            (widget.initialWeight! - widget.targetWeight!).abs() > 0.01)) {
      final initialDisplay =
          WeightConverter.forDisplay(widget.initialWeight!, widget.unit);
      horizontalLines.add(
        HorizontalLine(
          y: widget.initialWeight!,
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Time range selector
                    PopupMenuButton<ChartTimeRange>(
                      icon: Icon(
                        Icons.filter_list_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: context.l10n.timeRange,
                      onSelected: (range) {
                        setState(() {
                          _selectedTimeRange = range;
                          _zoomState = null; // Reset zoom when changing range
                        });
                      },
                      itemBuilder: (context) => ChartTimeRange.values
                          .map((range) => PopupMenuItem(
                                value: range,
                                child: Text(range.getLabel(context)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(width: 8),
                    // Help button
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
                              WeightConverter.forDisplay(value, widget.unit);
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
                              WeightConverter.forDisplay(e.value, widget.unit);
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
                  minX: _zoomState?.isZoomed == true ? _zoomState!.minX : 0,
                  maxX: _zoomState?.isZoomed == true 
                      ? _zoomState!.maxX 
                      : (displayed.length - 1).toDouble(),
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

  /// Filter weekly medians by selected time range
  List<MapEntry<DateTime, double>> _filterByTimeRange(
      List<MapEntry<DateTime, double>> medians) {
    final startDate = _selectedTimeRange.getStartDate();
    if (startDate == null) return medians;
    
    return medians.where((entry) => entry.key.isAfter(startDate) || 
        entry.key.isAtSameMomentAs(startDate)).toList();
  }

  /// Get zoomed data based on zoom state
  List<MapEntry<DateTime, double>> _getZoomedData(
      List<MapEntry<DateTime, double>> medians) {
    if (_zoomState == null || !_zoomState!.isZoomed) return medians;
    
    final startIndex = _zoomState!.minX.toInt().clamp(0, medians.length - 1);
    final endIndex = _zoomState!.maxX.toInt().clamp(0, medians.length - 1);
    
    if (startIndex >= endIndex) return medians;
    return medians.sublist(startIndex, endIndex + 1);
  }
}
