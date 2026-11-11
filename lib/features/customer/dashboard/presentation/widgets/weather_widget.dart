import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCFCE7)),
        boxShadow: AppColors.shadowSm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                '7 DAY FORECAST',
                style: AppTextStyle.labelSmall,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF14532D),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  'Lusaka, Zambia',
                  style: AppTextStyle.caption,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildForecastItem('Today', '24°', LucideIcons.cloud_rain, Colors.blue),
                const SizedBox(width: 12),
                _buildForecastItem('Tom', '22°', LucideIcons.cloud_lightning, Colors.amber),
                const SizedBox(width: 12),
                _buildForecastItem('Wed', '25°', LucideIcons.cloud, Colors.grey),
                const SizedBox(width: 12),
                _buildForecastItem('Thu', '28°', LucideIcons.sun, Colors.orange),
                const SizedBox(width: 12),
                _buildForecastItem('Fri', '27°', LucideIcons.sun, Colors.orange),
                const SizedBox(width: 12),
                _buildForecastItem('Sat', '23°', LucideIcons.cloud_rain, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastItem(String day, String temp, IconData icon, Color color) {
    return Column(
      children: [
        AppText(
          day.toUpperCase(),
          style: AppTextStyle.caption,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDCFCE7)),
            boxShadow: AppColors.shadowSm,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 8),
        AppText(temp, style: AppTextStyle.bodySmall, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ],
    );
  }
}
