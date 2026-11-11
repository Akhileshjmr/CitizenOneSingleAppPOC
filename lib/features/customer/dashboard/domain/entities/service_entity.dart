import 'package:flutter/material.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

enum ServiceType {
  banking,
  loans,
  healthcare,
  education,
  utilities,
}

class ServiceEntity {
  final String id;
  final String title;
  final String description;
  final String icon;
  final ServiceType type;
  final List<UserRole> availableTo;
  final String route;
  final Color? color;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.availableTo,
    required this.icon,
    this.route = '',
    this.color,
  });
}
