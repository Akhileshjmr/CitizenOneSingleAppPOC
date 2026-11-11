// ignore_for_file: prefer_const_constructors, inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/app.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/extensions/build_context_x.dart';
import 'package:citizenone_app/modules/insurance/core/network/session_image_headers.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/organisms.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';

/// Keyword classification shared by the mobile [ServiceSection] and the
/// desktop [_PolicyCard] grid so both surfaces map an API category name
/// (or its own fallback title) to the same icon/description family.
enum _CategoryKind { health, motor, travel, life, other }

_CategoryKind _kindOf(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('motor')) return _CategoryKind.motor;
  if (lower.contains('health')) return _CategoryKind.health;
  if (lower.contains('travel')) return _CategoryKind.travel;
  if (lower.contains('life')) return _CategoryKind.life;
  return _CategoryKind.other;
}

String _mobileIconFor(String name) {
  switch (_kindOf(name)) {
    case _CategoryKind.motor:
      return AppAssets.truck;
    case _CategoryKind.health:
      return AppAssets.healthAndSafety;
    case _CategoryKind.travel:
      return AppAssets.travel;
    case _CategoryKind.life:
      return AppAssets.heartTick;
    case _CategoryKind.other:
      return AppAssets.iconShield;
  }
}

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  late SecureStorageService secureStorageService;
  String vendorLogo = '';
  @override
  void initState() {
    super.initState();
    _loadVendorLogo();
    context.read<InsuranceBloc>().add(
          FetchInsuranceCategoriesEvent(vendorCode: 'VDR190526234'),
        );
  }

  Future<void> _loadVendorLogo() async {
    final data = await sl<SecureStorageService>().getVendorLogo();
    if (!mounted) return;
    if (data != null && data.isNotEmpty) {
      setState(() {
        vendorLogo = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (!context.isMobile) {
      return _buildDesktopBody(context);
    }

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          AppShell.of(context).onExit();
        },
        child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
                centerTitle: true,
                title: vendorLogo == ''
                    ? AppText('Insurance')
                    : SizedBox(
                        width: 40,
                        height: 40,
                        child: ClipOval(
                          child: AppNetworkImage(
                            vendorLogo,
                            headers: sessionImageHeaders(),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorWidget: SvgPicture.asset(
                              package: AppConfig.packageName,
                              AppAssets.iconShield,
                            ),
                          ),
                        ),
                      ),
                actions: [
                  InkWell(
                      onTap: () => AppShell.of(context).onExit(),
                      child: Image.asset(AppAssets.home,
                          package: AppConfig.packageName)),
                  HSpace(20)
                ]),
            body: SingleChildScrollView(
                child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: context.layout.maxContentWidth),
                        child: Column(children: [
                          Image.asset(
                              package: AppConfig.packageName,
                              AppAssets.motorInsuranceBanner1),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          QuickActionsSection(
                                              title: 'Quick Actions',
                                              items: [
                                                ActionItem(
                                                    disable: true,
                                                    title: 'Buy Policy',
                                                    icon: AppAssets.add,
                                                    backgroundColor:
                                                        colors.border,
                                                    iconColor:
                                                        colors.textPrimary,
                                                    onTap: () {
                                                      context
                                                          .push('/buy-policy');
                                                    }),
                                                ActionItem(
                                                    disable: true,
                                                    onTap: () {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             MotorInsuranceCreationScreen()));
                                                    },
                                                    title: 'Apply Claim',
                                                    icon: AppAssets.doc,
                                                    backgroundColor:
                                                        const Color(0xFFFEF3C7),
                                                    iconColor: const Color(
                                                        0xFFD97706)),
                                                ActionItem(
                                                    disable: true,
                                                    onTap: () {},
                                                    title: 'Pay Premium',
                                                    icon: AppAssets.pay,
                                                    backgroundColor: colors
                                                        .secondaryContainer,
                                                    iconColor:
                                                        colors.secondary),
                                                ActionItem(
                                                    disable: true,
                                                    onTap: () {},
                                                    title: 'My Docs',
                                                    icon: AppAssets.menuBook,
                                                    backgroundColor:
                                                        AppColors.brandLavender,
                                                    iconColor: colors.info)
                                              ]),
                                          const SizedBox(
                                              height: AppSpacing.xxxl),
                                          ServiceSection(
                                              title: 'Explore Policies',
                                              items: [
                                                ServiceItem(
                                                    icon: AppAssets.truck,
                                                    label: 'Motor',
                                                    onTap: () {
                                                      context.push(AppRoutes
                                                          .motorInsuranceCreationScreen);
                                                    }),
                                                ServiceItem(
                                                    icon: AppAssets
                                                        .healthAndSafety,
                                                    label: 'Health',
                                                    onTap: () {},
                                                    disable: true),
                                                ServiceItem(
                                                    icon: AppAssets.travel,
                                                    label: 'Travel',
                                                    onTap: () {},
                                                    disable: true),
                                                ServiceItem(
                                                    icon: AppAssets.heartTick,
                                                    label: 'Life',
                                                    onTap: () {},
                                                    disable: true)
                                              ])
                                        ]),
                                    // const SizedBox(height: AppSpacing.xxxl),
                                  ]))
                        ]))))));
  }

  // ── Desktop / tablet landing layout ──────────────────────────────────────
  // The permanent sidebar + header are provided by the outer ShellRoute
  // (AppDesktopShell), so this only renders the page content — no AppBar.
  Widget _buildDesktopBody(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _DesktopHero(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 32),
            child: ResponsiveContainer(
                padHorizontal: false,
                child: BlocBuilder<InsuranceBloc, InsuranceState>(
                    builder: (context, state) {
                  return _DesktopExplorePolicies(state: state);
                })))
      ])),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: const Color(0xFFEFF3FB),
        padding: const EdgeInsets.fromLTRB(80, 48, 80, 24),
        child: ResponsiveContainer(
            padHorizontal: false,
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const AppText(
                        'NEW: MOTOR COMPREHENSIVE',
                        style: AppTextStyle.labelSmall,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AppText(
                      "Zambia's Trusted Digital Insurance Hub",
                      style: AppTextStyle.headlineLarge,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.15,
                    ),
                    const SizedBox(height: 16),
                    const AppText(
                      'Secure complete protection for your vehicle, health, and '
                      'family instantly. Partnered with ZamPost and top local '
                      'providers.',
                      style: AppTextStyle.bodyLarge,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                  flex: 4,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                          package: AppConfig.packageName,
                          AppAssets.motorInsuranceBanner1,
                          fit: BoxFit.cover)))
            ])));
  }
}

class _DesktopExplorePolicies extends StatelessWidget {
  const _DesktopExplorePolicies({required this.state});

  final InsuranceState state;

  static const _fallback = [
    (
      icon: Icons.directions_car_filled_outlined,
      color: AppColors.brandBlue,
      iconBackground: Color(0xFFEEF4FF),
      title: 'Motor Insurance',
      desc: 'Third-party liability & comprehensive safety against damages.',
    ),
    (
      icon: Icons.health_and_safety_outlined,
      color: AppColors.brandGreen,
      iconBackground: Color(0xFFECFDF5),
      title: 'Health & Medical',
      desc: 'Global & local treatments powered by SafeGuard networks.',
    ),
    (
      icon: Icons.flight_outlined,
      color: AppColors.brandPink,
      iconBackground: Color(0xFFFFF1F2),
      title: 'Travel Protection',
      desc: 'Flight delay, baggage loss, emergency rescue coverage.',
    ),
    (
      icon: Icons.favorite_border,
      color: AppColors.brandPurple,
      iconBackground: Color(0xFFF8F2FF),
      title: 'Life Guard',
      desc: 'Secured legacy and family stability with zero-fuss claims.',
    ),
  ];

  /// Presentation-only fallback: the API's category `desc` is frequently
  /// null/empty, but the card design requires a description to always be
  /// visible. Falls back to the matching `_fallback` entry's copy (by
  /// keyword) rather than leaving the card without one. Doesn't touch the
  /// Bloc/state/model — purely decides what string this widget displays.
  static String _displayDesc(String title, String? apiDesc) {
    final trimmed = apiDesc?.trim() ?? '';
    if (trimmed.isNotEmpty) return trimmed;
    final kind = _kindOf(title);
    if (kind == _CategoryKind.other) return '';
    for (final item in _fallback) {
      if (_kindOf(item.title) == kind) return item.desc;
    }
    return '';
  }

  /// Same keyword match as [_displayDesc], but for the icon/colors — so an
  /// API category named e.g. "Health" still gets the health styling instead
  /// of the generic shield placeholder.
  static ({IconData icon, Color color, Color iconBackground}) _styleFor(
      String title) {
    final kind = _kindOf(title);
    if (kind != _CategoryKind.other) {
      for (final item in _fallback) {
        if (_kindOf(item.title) == kind) {
          return (
            icon: item.icon,
            color: item.color,
            iconBackground: item.iconBackground
          );
        }
      }
    }
    return (
      icon: Icons.shield_outlined,
      color: AppColors.primary,
      iconBackground: AppColors.primary.withValues(alpha: 0.08),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loaded = state.categoriesStatus == InsuranceCategoriesStatus.loaded &&
        state.categories.length >= 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Explore Zambia Policies',
          style: AppTextStyle.headlineMedium,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 16),
        if (state.categoriesStatus == InsuranceCategoriesStatus.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (loaded)
          ResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            spacing: 24,
            runSpacing: 24,
            children: [
              for (final category in state.categories)
                _PolicyCard(
                  icon: _styleFor(category.name).icon,
                  color: _styleFor(category.name).color,
                  iconBackground: _styleFor(category.name).iconBackground,
                  title: category.name,
                  desc: _displayDesc(category.name, category.desc),
                  onTap: () {
                    if (_kindOf(category.name) == _CategoryKind.motor) {
                      context.push(AppRoutes.motorInsuranceScreen);
                    }
                  },
                ),
            ],
          )
        else
          ResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            spacing: 24,
            runSpacing: 24,
            children: [
              for (final item in _fallback)
                _PolicyCard(
                  icon: item.icon,
                  color: item.color,
                  iconBackground: item.iconBackground,
                  title: item.title,
                  desc: item.desc,
                  onTap: () {
                    if (_kindOf(item.title) == _CategoryKind.motor) {
                      context.push(AppRoutes.motorInsuranceScreen);
                    }
                  },
                ),
            ],
          ),
      ],
    );
  }
}

/// Desktop-only policy category card. Not shared with the mobile
/// `ServiceSection` — mobile keeps its own unmodified widget tree.
class _PolicyCard extends StatefulWidget {
  const _PolicyCard({
    required this.icon,
    required this.color,
    required this.iconBackground,
    required this.title,
    required this.desc,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color iconBackground;
  final String title;
  final String desc;
  final VoidCallback? onTap;

  @override
  State<_PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<_PolicyCard> {
  bool _hovering = false;

  static const _defaultBorder = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 180),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hovering ? AppColors.primary : _defaultBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovering ? 0.10 : 0.05),
                blurRadius: _hovering ? 24 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // IntrinsicHeight + a stretched Row let the icon stay pinned to
          // the top-left (fixed 96x96, via Align) while the text column
          // gets the *full* card height to vertically center itself
          // within — a plain Row(crossAxisAlignment: start) would only
          // ever give the text column its own shrink-wrapped height, so
          // centering it would have nothing to center against.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.iconBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        widget.title,
                        style: AppTextStyle.headlineSmall,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.desc.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        AppText(
                          widget.desc,
                          style: AppTextStyle.bodyMedium,
                          color: AppColors.textSecondary,
                          height: 1.5,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
