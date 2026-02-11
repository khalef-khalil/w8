import 'package:flutter/material.dart';
import 'package:gauges/gauges.dart';

/// Value 0-50 maps to angle -90 to 90 (bottom half). Angle = -90 + (v/50)*180.
double _valueToAngle(double v) {
  final t = (v / 50).clamp(0.0, 1.0);
  return -90 + t * 180;
}

/// Half-circle BMI gauge: 8 WHO segments, needle, value/category shown below the arc.
class BmiGauge extends StatelessWidget {
  const BmiGauge({
    super.key,
    required this.bmiValue,
    required this.categoryText,
    this.size = 260,
  });

  final double bmiValue;
  final String categoryText;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = bmiValue.clamp(0.0, 50.0);
    final intPart = displayValue.floor();
    final decPart = ((displayValue - intPart) * 10).round().clamp(0, 9);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size * 0.5,
          child: RadialGauge(
            axes: [
              RadialGaugeAxis(
                minValue: 0,
                maxValue: 50,
                minAngle: -90,
                maxAngle: 90,
                color: Colors.transparent,
                segments: [
                  RadialGaugeSegment(
                    minValue: 0,
                    maxValue: 16,
                    minAngle: _valueToAngle(0),
                    maxAngle: _valueToAngle(16),
                    color: const Color(0xFFB71C1C), // dark red - severe thinness
                  ),
                  RadialGaugeSegment(
                    minValue: 16,
                    maxValue: 17,
                    minAngle: _valueToAngle(16),
                    maxAngle: _valueToAngle(17),
                    color: const Color(0xFFD32F2F), // red - moderate thinness
                  ),
                  RadialGaugeSegment(
                    minValue: 17,
                    maxValue: 18.5,
                    minAngle: _valueToAngle(17),
                    maxAngle: _valueToAngle(18.5),
                    color: const Color(0xFFFFEB3B), // yellow - mild thinness
                  ),
                  RadialGaugeSegment(
                    minValue: 18.5,
                    maxValue: 25,
                    minAngle: _valueToAngle(18.5),
                    maxAngle: _valueToAngle(25),
                    color: const Color(0xFF4CAF50), // green - normal
                  ),
                  RadialGaugeSegment(
                    minValue: 25,
                    maxValue: 30,
                    minAngle: _valueToAngle(25),
                    maxAngle: _valueToAngle(30),
                    color: const Color(0xFFFFC107), // amber - overweight
                  ),
                  RadialGaugeSegment(
                    minValue: 30,
                    maxValue: 35,
                    minAngle: _valueToAngle(30),
                    maxAngle: _valueToAngle(35),
                    color: const Color(0xFFFF9800), // orange - obese I
                  ),
                  RadialGaugeSegment(
                    minValue: 35,
                    maxValue: 40,
                    minAngle: _valueToAngle(35),
                    maxAngle: _valueToAngle(40),
                    color: const Color(0xFFE53935), // red - obese II
                  ),
                  RadialGaugeSegment(
                    minValue: 40,
                    maxValue: 50,
                    minAngle: _valueToAngle(40),
                    maxAngle: _valueToAngle(50),
                    color: const Color(0xFFB71C1C), // dark red - obese III
                  ),
                ],
                pointers: [
                  RadialNeedlePointer(
                    minValue: 0,
                    maxValue: 50,
                    value: displayValue,
                    thicknessStart: 20,
                    thicknessEnd: 0,
                    knobRadiusAbsolute: 0,
                    centerOffset: 0.13,
                    length: 0.6,
                    color: const Color(0xFF1A1A1A),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$intPart',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              '.$decPart',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 0),
        Text(
          categoryText,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
