import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';

/// Screen showcasing the Performance Yield Graph with dummy data, interactive
/// controls, key statistics, historical daily yield breakdown, and quick copy guide.
class PerformanceYieldScreen extends StatefulWidget {
  const PerformanceYieldScreen({super.key});

  @override
  State<PerformanceYieldScreen> createState() => _PerformanceYieldScreenState();
}

class _PerformanceYieldScreenState extends State<PerformanceYieldScreen> {
  String _selectedPeriod = '30D';
  YieldChartDataPoint? _inspectedPoint;

  // Period datasets
  late List<YieldChartDataPoint> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = YieldChartDataPoint.sample30Days;
    // Default to the reference image point (21 Oct 2024, index 21)
    if (_currentData.length > 21) {
      _inspectedPoint = _currentData[21];
    }
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
      if (period == '7D') {
        _currentData = YieldChartDataPoint.sample30Days.sublist(23);
      } else if (period == '14D') {
        _currentData = YieldChartDataPoint.sample30Days.sublist(16);
      } else {
        _currentData = YieldChartDataPoint.sample30Days;
      }
      _inspectedPoint = _currentData.isNotEmpty ? _currentData.last : null;
    });
  }

  void _copyUsageSnippet(BuildContext context) {
    const snippet = '''
// To use this graph anywhere in your project:
import 'package:citizenone_app/design_system/design_system.dart';

// Simple default 30-day card:
const PerformanceYieldChartCard()

// Or fully customized:
PerformanceYieldChartCard(
  title: '30-Day Performance',
  periodBadgeText: 'Last 30 days',
  metricLabel: 'Current Daily Yield',
  metricValue: '5.5%',
  subMetricText: 'EGP · Sample data',
  changeBadgeText: '+0.2%',
  changeLabel: 'vs previous day',
  footerText: '30-day performance · Updated daily',
  dataPoints: YieldChartDataPoint.sample30Days,
  initialSelectedIndex: 21,
  lineColor: Color(0xFFE51937),
  onPointSelected: (point) {
    print('Selected: \${point.displayDate} -> \${point.displayValue}');
  },
)
''';

    Clipboard.setData(const ClipboardData(text: snippet));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Widget usage snippet copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF1E2631),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Performance & Yield',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2631),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2631)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _copyUsageSnippet(context),
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copy Widget Code'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFE51937),
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Period Selector Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['7D', '14D', '30D'].map((period) {
                    final isSelected = _selectedPeriod == period;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(period),
                        selected: isSelected,
                        onSelected: (_) => _onPeriodChanged(period),
                        selectedColor: const Color(0xFF1E2631),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF4B5563),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF1E2631)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16.0),

                // THE EXACT GRAPH CARD
                PerformanceYieldChartCard(
                  title: '30-Day Performance',
                  periodBadgeText: _selectedPeriod == '30D'
                      ? 'Last 30 days'
                      : 'Last $_selectedPeriod',
                  metricLabel: 'Current Daily Yield',
                  metricValue: '5.5%',
                  subMetricText: 'EGP · Sample data',
                  changeBadgeText: '+0.2%',
                  changeLabel: 'vs previous day',
                  footerText: '30-day performance · Updated daily',
                  dataPoints: _currentData,
                  initialSelectedIndex: _selectedPeriod == '30D' ? 21 : null,
                  lineColor: const Color(0xFFE51937),
                  onPointSelected: (point) {
                    setState(() {
                      _inspectedPoint = point;
                    });
                  },
                ),

                const SizedBox(height: 24.0),

                // Live Inspector Banner
                if (_inspectedPoint != null)
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.touch_app_rounded,
                            color: Color(0xFFE51937),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Inspected Point: ${_inspectedPoint!.displayDate}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E2631),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Value: ${_inspectedPoint!.displayValue} · Touch or drag on chart to inspect other dates',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24.0),

                // Key Statistics Cards
                const Text(
                  'Key Performance Metrics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2631),
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        label: '30-Day Peak',
                        value: '5.50%',
                        date: '29 Oct 2024',
                        icon: Icons.trending_up_rounded,
                        accentColor: const Color(0xFF12A150),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _buildMetricTile(
                        label: '30-Day Low',
                        value: '3.90%',
                        date: '30 Sep 2024',
                        icon: Icons.trending_flat_rounded,
                        accentColor: const Color(0xFFE51937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        label: 'Period Average',
                        value: '4.63%',
                        date: 'Past 30 days',
                        icon: Icons.insights_rounded,
                        accentColor: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: _buildMetricTile(
                        label: 'Net Growth',
                        value: '+1.60%',
                        date: 'Total change',
                        icon: Icons.pie_chart_outline_rounded,
                        accentColor: const Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28.0),

                // Quick Copy Guide Card
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242E38),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.code_rounded,
                                  color: Color(0xFF38BDF8), size: 22),
                              SizedBox(width: 8),
                              Text(
                                'Ready to Copy & Use',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _copyUsageSnippet(context),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.copy,
                                      size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Copy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This graph component is 100% self-contained in:\n'
                        'lib/design_system/molecules/performance_yield_chart_card.dart\n\n'
                        'It has zero third-party packages, includes built-in mock data matching this graph, '
                        'and can be dropped anywhere in any Flutter project.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String date,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E2631),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
