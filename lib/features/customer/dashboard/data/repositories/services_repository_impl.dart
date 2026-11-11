import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/customer/dashboard/domain/entities/service_entity.dart';
import 'package:citizenone_app/features/customer/dashboard/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  @override
  Future<List<ServiceEntity>> getServices(UserRole role) async {
    // Mock network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Filter services based on role
    return _allServices
        .where((service) => service.availableTo.contains(role))
        .toList();
  }
}

// Master list of services moved from services_provider.dart
final List<ServiceEntity> _allServices = [
  const ServiceEntity(
    id: 'wealth_1',
    title: 'Wealth Management',
    description: 'Investments & Savings',
    type: ServiceType.banking,
    icon: AppAssets.iconSavings,
    route: '/services/wealth',
    color: Color(0xFF7C3AED),
    availableTo: [UserRole.citizen, UserRole.farmer],
  ),
  const ServiceEntity(
    id: 'health_1',
    title: 'HealthEzy',
    description: 'Insurance & Healthcare',
    type: ServiceType.healthcare,
    icon: AppAssets.iconHealthEzy,
    route: '/services/health',
    color: Color(0xFFE91E63),
    availableTo: [UserRole.citizen, UserRole.farmer, UserRole.agent],
  ),
  const ServiceEntity(
    id: 'sport_1',
    title: 'Sport & Mind',
    description: 'Fitness & Wellness',
    type: ServiceType.healthcare,
    icon: AppAssets.iconExerciseBlue,
    route: '/services/sport',
    color: Color(0xFF14B8A6),
    availableTo: [UserRole.citizen],
  ),
  const ServiceEntity(
    id: 'gov_1',
    title: 'Government Services',
    description: 'Taxes, Permits & Licenses',
    type: ServiceType.utilities,
    icon: AppAssets.iconAccountBalance,
    route: '/services/gov',
    color: Color(0xFF3B82F6),
    availableTo: [UserRole.citizen, UserRole.agent, UserRole.farmer],
  ),
  const ServiceEntity(
    id: 'bank_1',
    title: 'Banking',
    description: 'Accounts & Transfers',
    type: ServiceType.banking,
    icon: AppAssets.iconBuilding,
    route: '/services/banking',
    color: Color(0xFF2563EB),
    availableTo: [UserRole.citizen, UserRole.agent, UserRole.farmer],
  ),
  const ServiceEntity(
    id: 'log_1',
    title: 'Logistics',
    description: 'Shipping & Delivery',
    type: ServiceType.utilities,
    icon: AppAssets.iconTruck,
    route: '/services/logistics',
    color: Color(0xFFF97316),
    availableTo: [UserRole.citizen, UserRole.agent, UserRole.farmer],
  ),
  const ServiceEntity(
    id: 'sme_1',
    title: 'SME Services',
    description: 'Business Registration & Support',
    type: ServiceType.banking,
    icon: AppAssets.iconCurrency,
    route: '/services/sme',
    color: Color(0xFF6366F1),
    availableTo: [UserRole.citizen, UserRole.agent],
  ),
  const ServiceEntity(
    id: 'agri_1',
    title: 'Agriculture Services',
    description: 'Crop Advisory & Subsidies',
    type: ServiceType.utilities,
    icon: AppAssets.iconAgriculture,
    route: '/services/agri',
    color: Color(0xFF10B981),
    availableTo: [UserRole.citizen, UserRole.farmer, UserRole.agent],
  ),
];
