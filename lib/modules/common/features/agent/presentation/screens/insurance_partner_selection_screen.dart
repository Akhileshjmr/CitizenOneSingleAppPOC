import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import '../widgets/insurance_sidebar.dart';

class InsurancePartnerSelectionScreen extends StatefulWidget {
  const InsurancePartnerSelectionScreen({super.key});

  @override
  State<InsurancePartnerSelectionScreen> createState() =>
      _InsurancePartnerSelectionScreenState();
}

class _InsurancePartnerSelectionScreenState
    extends State<InsurancePartnerSelectionScreen> {
  final _searchController = TextEditingController();
  int _selectedIndex = 0;

  final List<Map<String, String>> _partners = [
    {
      'code': 'SANLAM_ZM',
      'name': 'Sanlam Life Insurance',
      'desc': 'Motor, Comprehensive & Third Party Cover',
      'category': 'Life & General',
      'logo': 'sanlam',
    },
    {
      'code': 'HOLLARD_ZM',
      'name': 'Hollard Insurance Zambia',
      'desc': 'Commercial & Fleet Vehicle Policies',
      'category': 'General Insurance',
      'logo': 'hollard',
    },
    {
      'code': 'PROFESSIONAL_ZM',
      'name': 'Professional Insurance Corp',
      'desc': 'Agricultural Equipment & Vehicle Cover',
      'category': 'Specialized Cover',
      'logo': 'pic',
    },
    {
      'code': 'MADISON_ZM',
      'name': 'Madison General Insurance',
      'desc': 'Private Motor & Roadside Assistance',
      'category': 'Motor & Health',
      'logo': 'madison',
    },
  ];

  String _filter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSelectedPartner(BuildContext context) {
    final selected = _filteredPartners[_selectedIndex];
    final vendorCode = selected['code'] ?? '';

    // Show choice sheet: Launch Embedded Insurance Engine or Clean Architecture Flow
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Open ${selected['name']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your preferred insurance operational journey:',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                tileColor: AppColors.surfaceSoft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.outline),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.shield, color: AppColors.primary),
                ),
                title: const Text(
                  'Clean Architecture Insurance Portal',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: const Text(
                  'Browse Plans, Active Policies, and Claims with Cubits',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(bottomContext).pop();
                  context.push('/insurance');
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: AppColors.surfaceSoft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.outline),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    LucideIcons.file_check,
                    color: Color(0xFFEF4444),
                  ),
                ),
                title: const Text(
                  'Transactional Motor Insurance Engine',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: const Text(
                  'Full policy quote, vehicle registration, and payment issuance',
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(bottomContext).pop();
                  context.push('/insurance/motor?vendorCode=$vendorCode');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> get _filteredPartners {
    if (_filter.isEmpty) return _partners;
    return _partners
        .where((p) =>
            p['name']!.toLowerCase().contains(_filter.toLowerCase()) ||
            p['category']!.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final partners = _filteredPartners;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Insurance Partners',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                children: [
                  const Text(
                    'Select Partner',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose an authorized insurance provider to issue motor covers or manage policy claims.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search insurance partners...',
                      prefixIcon: const Icon(LucideIcons.search, size: 20),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onChanged: (v) => setState(() {
                      _filter = v.trim();
                      _selectedIndex = 0;
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Partners List
                  ...partners.asMap().entries.map((entry) {
                    final index = entry.key;
                    final partner = entry.value;
                    final isSelected = index == _selectedIndex;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => setState(() => _selectedIndex = index),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.outline,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : AppColors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  LucideIcons.shield,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      partner['name']!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      partner['desc']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceSoft,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        partner['category']!,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? LucideIcons.circle_check
                                    : LucideIcons.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Continue Bottom Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.outline)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: partners.isEmpty
                      ? null
                      : () => _openSelectedPartner(context),
                  child: const Text(
                    'Continue with Partner',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
