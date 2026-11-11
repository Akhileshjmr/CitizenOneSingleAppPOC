import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ============================================================================
/// PERFORMANCE YIELD CHART CARD
/// ============================================================================
/// A self-contained, pixel-perfect, interactive Flutter chart card designed to
/// display 30-day (or customizable) yield/performance curves.
///
/// FEATURES:
/// - 100% Zero third-party dependencies (pure Flutter CustomPainter).
/// - Completely self-contained: copy this entire file into any Flutter project!
/// - Faithful reproduction of:
///     • Card container with rounded corners and subtle shadow
///     • Top header with "30-Day Performance" title and "Last 30 days" pill
///     • Thin horizontal separator
///     • Metric section with "Current Daily Yield", info icon, large "5.5%",
///       "EGP · Sample data" caption, and "+0.2% vs previous day" indicator
///     • Y-axis labels [6, 5.25, 4.5, 3.75, 3] and matching horizontal grid lines
///     • X-axis labels ["30 Sep", "14 Oct", "29 Oct"]
///     • Smooth crimson red cubic spline curve with soft vertical gradient fill
///     • Target/selected point circular hollow red dot at (21 Oct 2024, EGP 5.1152)
///     • Vertical reference guide line
///     • Dark slate tooltip callout box showing date and formatted value
///     • Interactive touch/drag/hover scrubbing across all data points
///     • Footer: "30-day performance · Updated daily"
/// ============================================================================

/// Represents an individual data point on the yield chart.
class YieldChartDataPoint {
  final DateTime date;
  final double value;
  final String? customFormattedValue;
  final String? label;

  const YieldChartDataPoint({
    required this.date,
    required this.value,
    this.customFormattedValue,
    this.label,
  });

  /// Formatted value string (e.g. "EGP 5.1152")
  String get displayValue =>
      customFormattedValue ?? 'EGP ${value.toStringAsFixed(4)}';

  /// Standard formatted date string (e.g. "21 Oct 2024")
  String get displayDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }

  /// Short date for axis (e.g. "21 Oct")
  String get shortDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  /// Complete 30-day dataset matching the reference image from 30 Sep 2024 to 29 Oct 2024.
  /// Exactly produces:
  /// - 30 Sep: ~3.90
  /// - 14 Oct: ~4.50
  /// - 21 Oct: 5.1152 (highlighted indicator in reference)
  /// - 29 Oct: 5.50 (current daily yield)
  static List<YieldChartDataPoint> get sample30Days {
    final values = <double>[
      3.90, // Sep 30
      3.93, // Oct 01
      3.96, // Oct 02
      3.98, // Oct 03
      4.02, // Oct 04
      4.08, // Oct 05
      4.14, // Oct 06
      4.19, // Oct 07
      4.24, // Oct 08
      4.27, // Oct 09
      4.31, // Oct 10
      4.36, // Oct 11
      4.42, // Oct 12
      4.47, // Oct 13
      4.50, // Oct 14
      4.55, // Oct 15
      4.61, // Oct 16
      4.68, // Oct 17
      4.78, // Oct 18
      4.89, // Oct 19
      5.00, // Oct 20
      5.1152, // Oct 21 (Selected key point)
      5.21, // Oct 22
      5.29, // Oct 23
      5.36, // Oct 24
      5.41, // Oct 25
      5.45, // Oct 26
      5.47, // Oct 27
      5.49, // Oct 28
      5.50, // Oct 29 (Current day)
    ];

    final startDate = DateTime(2024, 9, 30);
    return List.generate(values.length, (index) {
      final date = startDate.add(Duration(days: index));
      final val = values[index];
      return YieldChartDataPoint(
        date: date,
        value: val,
        customFormattedValue:
            index == 21 ? 'EGP 5.1152' : 'EGP ${val.toStringAsFixed(4)}',
      );
    });
  }
}

/// A standalone, production-ready Card widget containing the 30-Day Performance graph.
class PerformanceYieldChartCard extends StatefulWidget {
  /// Header title on the left. Defaults to "30-Day Performance".
  final String title;

  /// Period badge on top right. Defaults to "Last 30 days".
  final String periodBadgeText;

  /// Metric label above the primary value. Defaults to "Current Daily Yield".
  final String metricLabel;

  /// Large primary metric display. Defaults to "5.5%".
  final String metricValue;

  /// Subtitle below large metric. Defaults to "EGP · Sample data".
  final String subMetricText;

  /// Change badge text. Defaults to "+0.2%".
  final String changeBadgeText;

  /// Change label underneath badge. Defaults to "vs previous day".
  final String changeLabel;

  /// Footer caption text. Defaults to "30-day performance · Updated daily".
  final String footerText;

  /// Data points to plot. Defaults to [YieldChartDataPoint.sample30Days].
  final List<YieldChartDataPoint>? dataPoints;

  /// Default index to select/highlight. If null, defaults to index 21 (21 Oct 2024).
  final int? initialSelectedIndex;

  /// Minimum value on Y-axis. Defaults to 3.0.
  final double minY;

  /// Maximum value on Y-axis. Defaults to 6.0.
  final double maxY;

  /// Primary line and highlight color. Defaults to #E51937 (Crimson Red).
  final Color lineColor;

  /// Background color of the card. Defaults to Colors.white.
  final Color backgroundColor;

  /// Whether dragging or tapping enables interactive scrubbing. Defaults to true.
  final bool isInteractive;

  /// Optional callback when a data point is tapped/scrubbed.
  final ValueChanged<YieldChartDataPoint>? onPointSelected;

  /// Optional callback when Info icon is tapped.
  final VoidCallback? onInfoTap;

  const PerformanceYieldChartCard({
    super.key,
    this.title = '30-Day Performance',
    this.periodBadgeText = 'Last 30 days',
    this.metricLabel = 'Current Daily Yield',
    this.metricValue = '5.5%',
    this.subMetricText = 'EGP · Sample data',
    this.changeBadgeText = '+0.2%',
    this.changeLabel = 'vs previous day',
    this.footerText = '30-day performance · Updated daily',
    this.dataPoints,
    this.initialSelectedIndex,
    this.minY = 3.0,
    this.maxY = 6.0,
    this.lineColor = const Color(0xFFE51937),
    this.backgroundColor = Colors.white,
    this.isInteractive = true,
    this.onPointSelected,
    this.onInfoTap,
  });

  @override
  State<PerformanceYieldChartCard> createState() =>
      _PerformanceYieldChartCardState();
}

class _PerformanceYieldChartCardState extends State<PerformanceYieldChartCard>
    with SingleTickerProviderStateMixin {
  late List<YieldChartDataPoint> _points;
  late int _selectedIndex;
  late AnimationController _animController;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _points = widget.dataPoints ?? YieldChartDataPoint.sample30Days;
    _selectedIndex = widget.initialSelectedIndex ??
        (_points.length > 21 ? 21 : _points.length - 1);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _curveAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant PerformanceYieldChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataPoints != oldWidget.dataPoints &&
        widget.dataPoints != null) {
      _points = widget.dataPoints!;
      if (_selectedIndex >= _points.length) {
        _selectedIndex = _points.length - 1;
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTouch(Offset localPosition, Size chartSize) {
    if (!widget.isInteractive || _points.isEmpty) return;

    // Available plotting width is chart width minus left y-axis margin
    const double leftMargin = 40.0;
    const double rightMargin = 8.0;
    final plotWidth = chartSize.width - leftMargin - rightMargin;

    if (plotWidth <= 0) return;

    final touchX = (localPosition.dx - leftMargin).clamp(0.0, plotWidth);
    final ratio = touchX / plotWidth;
    final index = (ratio * (_points.length - 1)).round().clamp(0, _points.length - 1);

    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onPointSelected?.call(_points[_selectedIndex]);
    }
  }

  void _showInfoDialog(BuildContext context) {
    if (widget.onInfoTap != null) {
      widget.onInfoTap!();
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_outline_rounded,
                color: widget.lineColor, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Current Daily Yield',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Text(
          'The daily yield represents the annualized net rate of return '
          'calculated daily based on market benchmark performance. '
          'Updated every business morning.',
          style: TextStyle(fontSize: 13.5, height: 1.4, color: Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePoint =
        _points.isNotEmpty && _selectedIndex >= 0 && _selectedIndex < _points.length
            ? _points[_selectedIndex]
            : null;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: const Color(0xFFECEFF2), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TOP HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2631),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  widget.periodBadgeText,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14.0),

          // 2. THIN SEPARATOR DIVIDER
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFF2F4F7),
          ),

          const SizedBox(height: 18.0),

          // 3. STATS & METRICS ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column: Label + Info Icon, Large Metric Value, Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.metricLabel,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        GestureDetector(
                          onTap: () => _showInfoDialog(context),
                          behavior: HitTestBehavior.opaque,
                          child: const Icon(
                            Icons.info_outline_rounded,
                            size: 19.0,
                            color: Color(0xFF1E2631),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.metricValue,
                      style: const TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E2631),
                        letterSpacing: -0.8,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.subMetricText,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8C95A6),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Column: Green Pill Badge + Subtext
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F7EE),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_upward_rounded,
                          size: 13.0,
                          color: Color(0xFF12A150),
                        ),
                        const SizedBox(width: 3.0),
                        Text(
                          widget.changeBadgeText,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF12A150),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    widget.changeLabel,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6.0),

          // 4. CHART AREA (WITH CUSTOM PAINTER & INTERACTIVE SCRUBBING)
          SizedBox(
            height: 175.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanDown: (details) =>
                      _handleTouch(details.localPosition, constraints.biggest),
                  onPanUpdate: (details) =>
                      _handleTouch(details.localPosition, constraints.biggest),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedBuilder(
                    animation: _curveAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, 175.0),
                        painter: _YieldChartPainter(
                          points: _points,
                          selectedIndex: _selectedIndex,
                          selectedPoint: activePoint,
                          minY: widget.minY,
                          maxY: widget.maxY,
                          lineColor: widget.lineColor,
                          animationProgress: _curveAnimation.value,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12.0),

          // 5. FOOTER TEXT
          Center(
            child: Text(
              widget.footerText,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter executing the Y-axis, grid lines, smooth cubic spline curve,
/// soft area gradient, indicator dot, vertical line, and tooltip callout.
class _YieldChartPainter extends CustomPainter {
  final List<YieldChartDataPoint> points;
  final int selectedIndex;
  final YieldChartDataPoint? selectedPoint;
  final double minY;
  final double maxY;
  final Color lineColor;
  final double animationProgress;

  _YieldChartPainter({
    required this.points,
    required this.selectedIndex,
    required this.selectedPoint,
    required this.minY,
    required this.maxY,
    required this.lineColor,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Fixed margins
    const double leftMargin = 38.0;
    const double rightMargin = 12.0;
    const double topMargin = 46.0; // Room for tooltip callout
    const double bottomMargin = 24.0; // Room for X-axis labels

    const double chartLeft = leftMargin;
    final double chartRight = size.width - rightMargin;
    const double chartTop = topMargin;
    final double chartBottom = size.height - bottomMargin;
    final double chartWidth = chartRight - chartLeft;
    final double chartHeight = chartBottom - chartTop;

    // 1. DRAW Y-AXIS LABELS & HORIZONTAL GRID LINES
    // Levels: 6, 5.25, 4.5, 3.75, 3
    final yTicks = [6.0, 5.25, 4.5, 3.75, 3.0];
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F3F6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const labelStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w400,
      color: Color(0xFF6B7280),
    );

    for (final tick in yTicks) {
      final normalized = (tick - minY) / (maxY - minY);
      final yPos = chartBottom - (normalized * chartHeight);

      // Draw faint horizontal grid line
      canvas.drawLine(
        Offset(chartLeft, yPos),
        Offset(chartRight, yPos),
        gridPaint,
      );

      // Draw Y label text formatted cleanly: 6, 5.25, 4.5, 3.75, 3
      final String tickString = tick == tick.roundToDouble()
          ? tick.toInt().toString()
          : (tick * 10 == (tick * 10).roundToDouble()
              ? tick.toStringAsFixed(1)
              : tick.toStringAsFixed(2));

      final textSpan = TextSpan(text: tickString, style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(chartLeft - textPainter.width - 10.0, yPos - (textPainter.height / 2)),
      );
    }

    // 2. COMPUTE PIXEL COORDINATES FOR DATA POINTS
    final pointCoords = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final xFraction = points.length > 1 ? i / (points.length - 1) : 0.5;
      final x = chartLeft + (xFraction * chartWidth);

      // Value normalized against Y-scale, modulated by animation progress
      final rawValue = points[i].value;
      final val = minY + ((rawValue - minY) * animationProgress);
      final normalizedY = ((val - minY) / (maxY - minY)).clamp(0.0, 1.0);
      final y = chartBottom - (normalizedY * chartHeight);

      pointCoords.add(Offset(x, y));
    }

    // 3. BUILD ULTRA-SMOOTH CURVE PATH (FRITSCH-CARLSON MONOTONE CUBIC SPLINE)
    final curvePath = _buildSmoothSplinePath(pointCoords);

    // 4. DRAW GRADIENT AREA UNDER CURVE
    final fillPath = Path.from(curvePath);
    fillPath.lineTo(pointCoords.last.dx, chartBottom);
    fillPath.lineTo(pointCoords.first.dx, chartBottom);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.18),
          lineColor.withValues(alpha: 0.00),
        ],
      ).createShader(Rect.fromLTRB(chartLeft, chartTop, chartRight, chartBottom))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // 5. DRAW THE LINE STROKE
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(curvePath, linePaint);

    // 6. DRAW X-AXIS LABELS (e.g. "30 Sep", "14 Oct", "29 Oct")
    if (points.isNotEmpty) {
      // Start label
      _drawXLabel(canvas, points.first.shortDate, pointCoords.first.dx,
          chartBottom + 8.0, TextAlign.left);

      // Midpoint label
      if (points.length > 2) {
        final midIndex = points.length ~/ 2;
        _drawXLabel(canvas, points[midIndex].shortDate, pointCoords[midIndex].dx,
            chartBottom + 8.0, TextAlign.center);
      }

      // End label
      _drawXLabel(canvas, points.last.shortDate, pointCoords.last.dx,
          chartBottom + 8.0, TextAlign.right);
    }

    // 7. DRAW HIGHLIGHTED POINT (INDICATOR DOT & VERTICAL LINE)
    if (selectedIndex >= 0 && selectedIndex < pointCoords.length) {
      final selectedOffset = pointCoords[selectedIndex];

      // Vertical guide line dropping from dot to chartBottom
      final verticalLinePaint = Paint()
        ..color = const Color(0xFFD3D7DD)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(selectedOffset.dx, chartTop),
        Offset(selectedOffset.dx, chartBottom),
        verticalLinePaint,
      );

      // Hollow Red Circular Indicator Dot
      final outerDotPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6;

      final innerDotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      // Draw white center
      canvas.drawCircle(selectedOffset, 5.0, innerDotPaint);
      // Draw red stroke ring
      canvas.drawCircle(selectedOffset, 5.0, outerDotPaint);

      // 8. DRAW TOOLTIP CALLOUT
      if (selectedPoint != null) {
        _drawTooltip(
          canvas: canvas,
          targetPoint: selectedOffset,
          dateText: selectedPoint!.displayDate,
          valueText: selectedPoint!.displayValue,
          chartBounds: Rect.fromLTRB(chartLeft, 0, chartRight, chartBottom),
        );
      }
    }
  }

  void _drawXLabel(
    Canvas canvas,
    String text,
    double xPos,
    double yPos,
    TextAlign align,
  ) {
    const textStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w400,
      color: Color(0xFF6B7280),
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    double dx = xPos;
    if (align == TextAlign.center) {
      dx -= textPainter.width / 2;
    } else if (align == TextAlign.right) {
      dx -= textPainter.width;
    }

    textPainter.paint(canvas, Offset(dx, yPos));
  }

  void _drawTooltip({
    required Canvas canvas,
    required Offset targetPoint,
    required String dateText,
    required String valueText,
    required Rect chartBounds,
  }) {
    const dateStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF1F5F9),
      height: 1.2,
    );

    const valueStyle = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      height: 1.2,
    );

    final datePainter = TextPainter(
      text: TextSpan(text: dateText, style: dateStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final valuePainter = TextPainter(
      text: TextSpan(text: valueText, style: valueStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    const paddingH = 12.0;
    const paddingV = 7.0;
    const spacing = 3.0;

    final contentWidth =
        math.max(datePainter.width, valuePainter.width);
    final tooltipWidth = contentWidth + (paddingH * 2);
    final tooltipHeight =
        datePainter.height + valuePainter.height + spacing + (paddingV * 2);

    // Position tooltip right above target point
    double tooltipLeft = targetPoint.dx - (tooltipWidth / 2);
    // Keep horizontally within chart boundaries
    tooltipLeft = tooltipLeft.clamp(
      chartBounds.left,
      chartBounds.right - tooltipWidth,
    );

    // Place above target point with 10px gap
    double tooltipTop = targetPoint.dy - tooltipHeight - 12.0;
    if (tooltipTop < 0) {
      // If overflowing top, place slightly lower or clamp
      tooltipTop = 2.0;
    }

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipLeft, tooltipTop, tooltipWidth, tooltipHeight),
      const Radius.circular(8.0),
    );

    // Tooltip soft drop shadow
    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(tooltipRect.shift(const Offset(0, 3)), shadowPaint);

    // Tooltip background (#222B35 dark slate)
    final bgPaint = Paint()
      ..color = const Color(0xFF222B35)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(tooltipRect, bgPaint);

    // Paint text lines
    datePainter.paint(
      canvas,
      Offset(tooltipLeft + paddingH, tooltipTop + paddingV),
    );
    valuePainter.paint(
      canvas,
      Offset(
        tooltipLeft + paddingH,
        tooltipTop + paddingV + datePainter.height + spacing,
      ),
    );
  }

  /// Constructs an ultra-smooth, continuous C1 cubic spline using the
  /// Fritsch-Carlson monotone cubic interpolation algorithm.
  /// This prevents unnatural overshoots/undershoots, eliminates sharp kinks,
  /// and produces a fluid, aesthetic financial yield curve.
  static Path _buildSmoothSplinePath(List<Offset> pts) {
    final path = Path();
    if (pts.isEmpty) return path;
    if (pts.length == 1) {
      path.moveTo(pts[0].dx, pts[0].dy);
      return path;
    }
    if (pts.length == 2) {
      path.moveTo(pts[0].dx, pts[0].dy);
      path.lineTo(pts[1].dx, pts[1].dy);
      return path;
    }

    final n = pts.length;
    final d = List<double>.filled(n - 1, 0.0);
    final m = List<double>.filled(n, 0.0);

    // 1. Calculate secants (slopes between consecutive points)
    for (int i = 0; i < n - 1; i++) {
      final dx = pts[i + 1].dx - pts[i].dx;
      final dy = pts[i + 1].dy - pts[i].dy;
      d[i] = dx != 0.0 ? dy / dx : 0.0;
    }

    // 2. Initialize tangents as averages of adjacent secants
    m[0] = d[0];
    m[n - 1] = d[n - 2];
    for (int i = 1; i < n - 1; i++) {
      if (d[i - 1] * d[i] <= 0) {
        m[i] = 0.0;
      } else {
        m[i] = (d[i - 1] + d[i]) / 2.0;
      }
    }

    // 3. Fritsch-Carlson condition for monotonicity and smooth transition
    for (int i = 0; i < n - 1; i++) {
      if (d[i] == 0.0) {
        m[i] = 0.0;
        m[i + 1] = 0.0;
      } else {
        final alpha = m[i] / d[i];
        final beta = m[i + 1] / d[i];
        final dist = (alpha * alpha) + (beta * beta);
        if (dist > 9.0) {
          final tau = 3.0 / math.sqrt(dist);
          m[i] = tau * alpha * d[i];
          m[i + 1] = tau * beta * d[i];
        }
      }
    }

    // 4. Transform Hermite segments into cubic Bézier control points
    path.moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < n - 1; i++) {
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final dx = p2.dx - p1.dx;
      final thirdDx = dx / 3.0;

      final cp1x = p1.dx + thirdDx;
      final cp1y = p1.dy + (m[i] * thirdDx);
      final cp2x = p2.dx - thirdDx;
      final cp2y = p2.dy - (m[i + 1] * thirdDx);

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _YieldChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.selectedPoint != selectedPoint ||
        oldDelegate.points != points ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.lineColor != lineColor;
  }
}
