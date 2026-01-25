import 'package:flutter/material.dart';

/// Animated progress bar with milestone markers
class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  final bool showMilestones;
  final List<double>? milestones; // Custom milestone positions (0.0 to 1.0)

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.progressColor,
    this.height = 12.0,
    this.showMilestones = true,
    this.milestones,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<double> get _milestones {
    if (widget.milestones != null) {
      return widget.milestones!;
    }
    return widget.showMilestones ? [0.25, 0.50, 0.75] : [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ??
        theme.colorScheme.surfaceContainerHighest;
    final progressColor = widget.progressColor ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedProgress = widget.progress * _animation.value;
        
        return Stack(
          children: [
            // Background
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.height / 2),
              child: Container(
                height: widget.height,
                color: backgroundColor,
              ),
            ),
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.height / 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: widget.height,
                  width: MediaQuery.of(context).size.width * animatedProgress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor,
                        progressColor.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Milestone markers
            if (_milestones.isNotEmpty)
              ..._milestones.map((milestone) {
                if (milestone > animatedProgress) return const SizedBox.shrink();
                return Positioned(
                  left: MediaQuery.of(context).size.width * milestone - 2,
                  top: 0,
                  child: Container(
                    width: 4,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}
