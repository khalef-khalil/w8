import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../core/utils/weight_converter.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/models/chart_time_range.dart';
import '../../../core/services/metrics_cache.dart';
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
    // Use cached weekly medians for better performance
    final weeklyMedians = MetricsCache.getWeeklyMedians(
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
                    Semantics(
                      label: context.l10n.timeRange,
                      button: true,
                      child: PopupMenuButton<ChartTimeRange>(
                        icon: Icon(
                          Icons.filter_list_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: context.l10n.timeRange,
                      onSelected: (range) {
                        setState(() {
                          _selectedTimeRange = range;
                          _zoomState = null;                     // Reset zoom when changing range
                        _zoomState = null;
                      });
                    },
                      itemBuilder: (context) => ChartTimeRange.values
                          .map((range) => PopupMenuItem(
                                value: range,
                                child: Text(range.getLabel(context)),
                              ))
                          .toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Help button
                    Semantics(
                      label: context.l10n.learnMore,
                      button: true,
                      child: EducationButton(
                        contentId: 'weekly_medians',
                        tooltip: context.l10n.learnMore,
                        child: Icon(
                          Icons.help_outline_rounded,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Zoom hint
            if (_zoomState?.isZoomed == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.zoom_out_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.zoomedIn,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Semantics(
                      label: context.l10n.resetZoom,
                      button: true,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _zoomState = null;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: const Size(44, 44), // Ensure minimum touch target
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          context.l10n.resetZoom,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            // Data table for screen readers
            Semantics(
              label: _buildChartDataTableLabel(context, displayed),
              child: ExcludeSemantics(
                child: SizedBox(
                  height: chartHeight,
                  child: GestureDetector(
                onScaleStart: (details) {
                  // Store initial zoom state when starting pinch
                  if (_zoomState == null || !_zoomState!.isZoomed) {
                    setState(() {
                      _zoomState = _ChartZoomState()
                        ..minX = 0
                        ..maxX = (displayed.length - 1).toDouble()
                        ..minY = minY
                        ..maxY = maxY
                        ..isZoomed = false;
                    });
                  }
                },
                onScaleUpdate: (details) {
                  if (details.scale != 1.0) {
                    // Pinch to zoom
                    setState(() {
                      if (_zoomState != null) {
                        final centerX = (_zoomState!.minX + _zoomState!.maxX) / 2;
                        final centerY = (_zoomState!.minY + _zoomState!.maxY) / 2;
                        final rangeX = _zoomState!.maxX - _zoomState!.minX;
                        final rangeY = _zoomState!.maxY - _zoomState!.minY;
                        
                        final newRangeX = rangeX / details.scale;
                        final newRangeY = rangeY / details.scale;
                        
                        _zoomState!.minX = (centerX - newRangeX / 2).clamp(0.0, (displayed.length - 1).toDouble());
                        _zoomState!.maxX = (centerX + newRangeX / 2).clamp(0.0, (displayed.length - 1).toDouble());
                        _zoomState!.minY = (centerY - newRangeY / 2).clamp(minY, maxY);
                        _zoomState!.maxY = (centerY + newRangeY / 2).clamp(minY, maxY);
                        _zoomState!.isZoomed = true;
                      }
                    });
                  } else if (details.focalPointDelta.dx != 0 || details.focalPointDelta.dy != 0) {
                    // Pan when zoomed
                    if (_zoomState?.isZoomed == true) {
                      setState(() {
                        final rangeX = _zoomState!.maxX - _zoomState!.minX;
                        final rangeY = _zoomState!.maxY - _zoomState!.minY;
                        final panFactorX = details.focalPointDelta.dx / size.width;
                        final panFactorY = -details.focalPointDelta.dy / chartHeight; // Invert Y
                        
                        final deltaX = panFactorX * rangeX;
                        final deltaY = panFactorY * rangeY;
                        
                        final newMinX = (_zoomState!.minX - deltaX).clamp(0.0, (displayed.length - 1).toDouble() - rangeX);
                        final newMaxX = newMinX + rangeX;
                        final newMinY = (_zoomState!.minY - deltaY).clamp(minY, maxY - rangeY);
                        final newMaxY = newMinY + rangeY;
                        
                        _zoomState!.minX = newMinX;
                        _zoomState!.maxX = newMaxX;
                        _zoomState!.minY = newMinY;
                        _zoomState!.maxY = newMaxY;
                      });
                    }
                  }
                },
                onScaleEnd: (details) {
                  // Optional: Reset zoom if scale is too small
                  if (_zoomState?.isZoomed == true) {
                    final rangeX = _zoomState!.maxX - _zoomState!.minX;
                    final totalRange = (displayed.length - 1).toDouble();
                    if (rangeX >= totalRange * 0.95) {
                      // Reset zoom if zoomed out too much
                      setState(() {
                        _zoomState = null;
                      });
                    }
                }
                },
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
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      // Handle tap to focus on specific points
                      if (event is FlTapUpEvent && touchResponse != null) {
                        final spot = touchResponse.lineBarSpots?.firstOrNull;
                        if (spot != null) {
                          // Could show detailed info dialog here
                        }
                      }
                    },
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
                  minX: _zoomState?.isZoomed == true 
                      ? _zoomState!.minX.clamp(0.0, (displayed.length - 1).toDouble())
                      : 0,
                  maxX: _zoomState?.isZoomed == true 
                      ? _zoomState!.maxX.clamp(0.0, (displayed.length - 1).toDouble())
                      : (displayed.length - 1).toDouble(),
                  minY: _zoomState?.isZoomed == true ? _zoomState!.minY : minY,
                  maxY: _zoomState?.isZoomed == true ? _zoomState!.maxY : maxY,
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
            ),
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

  /// Build accessible data table label for screen readers
  String _buildChartDataTableLabel(
      BuildContext context, List<MapEntry<DateTime, double>> displayed) {
    if (displayed.isEmpty) {
      return context.l10n.notEnoughData;
    }

    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final unitStr = widget.unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;
    final buffer = StringBuffer();
    buffer.writeln('${l10n.weeklyEvolution}. ${displayed.length} ${l10n.dataPoints}.');

    // Show first, middle, and last points for brevity
    if (displayed.length <= 5) {
      // Show all if 5 or fewer
      for (final entry in displayed) {
        final dateStr = DateFormat.yMMMd(locale).format(entry.key);
        final weightStr = WeightConverter.forDisplay(entry.value, widget.unit)
            .toStringAsFixed(2);
        buffer.writeln('$dateStr: $weightStr $unitStr');
      }
    } else {
      // Show first, middle, last
      final first = displayed.first;
      final middle = displayed[displayed.length ~/ 2];
      final last = displayed.last;

      final firstDate = DateFormat.yMMMd(locale).format(first.key);
      final firstWeight = WeightConverter.forDisplay(first.value, widget.unit)
          .toStringAsFixed(2);
      buffer.writeln('$firstDate: $firstWeight $unitStr');

      final middleDate = DateFormat.yMMMd(locale).format(middle.key);
      final middleWeight = WeightConverter.forDisplay(middle.value, widget.unit)
          .toStringAsFixed(2);
      buffer.writeln('${l10n.midpoint}: $middleDate: $middleWeight $unitStr');

      final lastDate = DateFormat.yMMMd(locale).format(last.key);
      final lastWeight = WeightConverter.forDisplay(last.value, widget.unit)
          .toStringAsFixed(2);
      buffer.writeln('${l10n.latest}: $lastDate: $lastWeight $unitStr');
    }

    return buffer.toString();
  }
}
