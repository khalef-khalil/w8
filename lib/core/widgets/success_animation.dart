import 'package:flutter/material.dart';

/// Simple success checkmark animation
class SuccessAnimation extends StatefulWidget {
  final double size;
  final Color? color;

  const SuccessAnimation({
    super.key,
    this.size = 64,
    this.color,
  });

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkmarkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color ?? Theme.of(context).colorScheme.primary,
        ),
        child: AnimatedBuilder(
          animation: _checkmarkAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: _CheckmarkPainter(
                progress: _checkmarkAnimation.value,
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: widget.size * 0.1,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final checkSize = size.width * 0.3;

    // Draw checkmark
    path.moveTo(centerX - checkSize, centerY);
    path.lineTo(centerX - checkSize * 0.3, centerY + checkSize * 0.6);
    path.lineTo(centerX + checkSize, centerY - checkSize * 0.3);

    // Animate the checkmark drawing
    final pathMetrics = path.computeMetrics();
    if (pathMetrics.isEmpty) return;
    final animatedPath = pathMetrics.first;
    final pathLength = animatedPath.length;
    final pathToDraw = animatedPath.extractPath(0, pathLength * progress);

    canvas.drawPath(pathToDraw, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
