import 'package:flutter/material.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';

/// Generic gradient hero-card shell used across all role dashboards.
///
/// Slots:
/// - [header]  — role chip / label row
/// - [metric]  — value display block
/// - [actions] — primary + secondary buttons
/// - [note]    — optional small text shown only in the desktop right column
///
/// Layout:
/// - Mobile  → Column(header, metric, actions)
/// - Desktop → Row(Column(header, metric) | divider | Column(actions, note))
class HeroCardShell extends StatelessWidget {
  final LinearGradient gradient;
  final Color shadowColor;
  final Widget header;
  final Widget metric;
  final Widget actions;
  final Widget? note;
  final bool isDark;

  const HeroCardShell({
    super.key,
    required this.gradient,
    required this.shadowColor,
    required this.header,
    required this.metric,
    required this.actions,
    this.note,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = AdaptiveLayout.isDesktop(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop ? double.infinity : 800,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: isDesktop
              ? _DesktopSlots(
                  header: header,
                  metric: metric,
                  actions: actions,
                  note: note,
                  isDark: isDark,
                )
              : _MobileSlots(header: header, metric: metric, actions: actions),
        ),
      ),
    );
  }
}

class _MobileSlots extends StatelessWidget {
  final Widget header;
  final Widget metric;
  final Widget actions;

  const _MobileSlots({
    required this.header,
    required this.metric,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          const SizedBox(height: 8),
          metric,
          const SizedBox(height: 8),
          actions,
        ],
      ),
    );
  }
}

class _DesktopSlots extends StatelessWidget {
  final Widget header;
  final Widget metric;
  final Widget actions;
  final Widget? note;
  final bool isDark;

  const _DesktopSlots({
    required this.header,
    required this.metric,
    required this.actions,
    required this.isDark,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [header, const SizedBox(height: 12), metric],
            ),
          ),
          Container(
            width: 1,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
          ),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                actions,
                if (note != null) ...[const SizedBox(height: 12), note!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
