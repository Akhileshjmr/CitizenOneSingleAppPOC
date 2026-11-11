import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/features/customer/dashboard/domain/entities/service_entity.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class ServiceCard extends StatelessWidget {
  final ServiceEntity service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final color = service.color ?? tokens.primary;

    return PressScaleWidget(
      onPressed: () {
        if (service.route.isNotEmpty) context.push(service.route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tokens.background,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                service.icon,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                placeholderBuilder: (_) =>
                    Icon(Icons.apps_rounded, size: 28, color: color),
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.apps_rounded, size: 28, color: color),
              ),
            ),
          ),
          const SizedBox(height: 8),
          AppText(
            service.title,
            style: AppTextStyle.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
