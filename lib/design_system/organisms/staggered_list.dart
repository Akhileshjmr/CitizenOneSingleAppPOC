import 'package:flutter/material.dart';

/// Animates children in with a staggered slide-up + fade effect.
class StaggeredEntryList extends StatefulWidget {
  final List<Widget> children;
  final double verticalOffset;
  final Duration duration;
  final Duration delay;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const StaggeredEntryList({
    super.key,
    required this.children,
    this.verticalOffset = 20.0,
    this.duration = const Duration(milliseconds: 400),
    this.delay = const Duration(milliseconds: 50),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  State<StaggeredEntryList> createState() => _StaggeredEntryListState();
}

class _StaggeredEntryListState extends State<StaggeredEntryList>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    final totalMs =
        widget.duration.inMilliseconds +
        widget.delay.inMilliseconds * (widget.children.length - 1);

    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    _fades = [];
    _slides = [];

    for (int i = 0; i < widget.children.length; i++) {
      final startMs = widget.delay.inMilliseconds * i;
      final start = startMs / totalMs;
      final end = ((startMs + widget.duration.inMilliseconds) / totalMs)
          .clamp(0.0, 1.0);

      final curve = CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

      _fades.add(Tween<double>(begin: 0.0, end: 1.0).animate(curve));
      _slides.add(Tween<Offset>(
        begin: Offset(0, widget.verticalOffset),
        end: Offset.zero,
      ).animate(curve));
    }

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: List.generate(widget.children.length, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Transform.translate(
            offset: _slides[i].value,
            child: Opacity(opacity: _fades[i].value, child: child),
          ),
          child: widget.children[i],
        );
      }),
    );
  }
}
