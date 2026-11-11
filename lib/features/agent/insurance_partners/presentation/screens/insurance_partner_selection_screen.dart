import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/network/session_image_headers.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_loader.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/molecules/search_field.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/state/insurance_partner_cubit.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/state/insurance_partner_state.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/widgets/insurance_sidebar.dart'
    show showLogoutDialog;
import 'package:citizenone_app/features/kyc/domain/usecases/get_agent_mobile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/modules/insurance/module/module_entry.dart';

class InsurancePartnerSelectionScreen extends StatelessWidget {
  const InsurancePartnerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<InsurancePartnerCubit>()..loadProviders(),
    child: const _InsurancePartnerSelectionView(),
  );
}

class _InsurancePartnerSelectionView extends StatefulWidget {
  const _InsurancePartnerSelectionView();

  @override
  State<_InsurancePartnerSelectionView> createState() =>
      _InsurancePartnerSelectionViewState();
}

class _InsurancePartnerSelectionViewState
    extends State<_InsurancePartnerSelectionView> {
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      context.read<InsurancePartnerCubit>().onSearchFocused();
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrow_left, color: tokens.textPrimary),
          onPressed: () {
            _searchFocusNode.unfocus();
            Navigator.of(context).pop();
          },
        ),
        title: AppText(
          'Partner',
          style: AppTextStyle.headlineSmall,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<InsurancePartnerCubit, InsurancePartnerState>(
          builder: (context, state) => Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _searchFocusNode.unfocus,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      AppText(
                        'Select Partner',
                        style: AppTextStyle.headlineSmall,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        'Choose assigned partner to access operations',
                        style: AppTextStyle.bodyMedium,
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 24),
                      SearchField(
                        hintText: 'Search partners',
                        focusNode: _searchFocusNode,
                        onChanged: context
                            .read<InsurancePartnerCubit>()
                            .updateSearch,
                      ),
                      const SizedBox(height: 20),
                      _ProviderContent(
                        state: state,
                        onTileTap: _searchFocusNode.unfocus,
                      ),
                    ],
                  ),
                ),
              ),
              _Footer(state: state, onBeforeContinue: _searchFocusNode.unfocus),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderContent extends StatelessWidget {
  final InsurancePartnerState state;
  final VoidCallback onTileTap;
  const _ProviderContent({required this.state, required this.onTileTap});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InsurancePartnerCubit>();
    final tokens = context.appTokens;
    if (state.status == InsurancePartnerStatus.loading ||
        state.status == InsurancePartnerStatus.initial) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 56),
        child: Center(child: AppLoader()),
      );
    }
    if (state.status == InsurancePartnerStatus.failure) {
      return _StatusMessage(
        icon: LucideIcons.wifi_off,
        message: state.errorMessage ?? 'Unable to load insurance partners.',
        actionLabel: 'Retry',
        onAction: cubit.loadProviders,
      );
    }
    if (state.providers.isEmpty) {
      return const _StatusMessage(
        icon: LucideIcons.shield_off,
        message: 'No insurance partners available',
      );
    }
    final providers = state.filteredProviders;
    if (providers.isEmpty) {
      return const _StatusMessage(
        icon: LucideIcons.search_x,
        message: 'No insurance partners match your search',
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tokens.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Insurance Partners',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: tokens.outline),
          for (var index = 0; index < providers.length; index++) ...[
            _ProviderTile(
              provider: providers[index],
              selected: state.selectedProvider == providers[index],
              onTap: () {
                onTileTap();
                cubit.selectProvider(providers[index]);
              },
            ),
            if (index != providers.length - 1)
              Divider(height: 1, color: tokens.outline),
          ],
        ],
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  final InsuranceProvider provider;
  final bool selected;
  final VoidCallback onTap;
  const _ProviderTile({
    required this.provider,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Material(
      color: selected
          ? tokens.primary.withValues(alpha: 0.08)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _ProviderLogo(provider: provider),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      provider.vendorName,
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w700,
                    ),
                    if (provider.vendorDesc.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      AppText(
                        provider.vendorDesc,
                        style: AppTextStyle.bodySmall,
                        color: tokens.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderLogo extends StatelessWidget {
  final InsuranceProvider provider;
  const _ProviderLogo({required this.provider});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final url = provider.vendorLogo.isEmpty
        ? null
        : sl<AppEnv>().insuranceUri(provider.vendorLogo).toString();
    return Container(
      height: 48,
      width: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tokens.surfaceSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: url == null
          ? Icon(LucideIcons.shield_check, color: AppColors.textMain)
          : Image.network(
              url,
              headers: sessionImageHeaders(),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(LucideIcons.shield_check, color: AppColors.textMain),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : const Center(child: AppLoader(size: 20)),
            ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _StatusMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 32, color: tokens.textMuted),
            const SizedBox(height: 12),
            AppText(
              message,
              style: AppTextStyle.bodyMedium,
              color: tokens.textSecondary,
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 16),
              AppButton(
                text: actionLabel!,
                onPressed: onAction!,
                variant: AppButtonVariant.outline,
                width: 112,
                foregroundColor: tokens.primary,
                borderColor: tokens.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final InsurancePartnerState state;
  final VoidCallback onBeforeContinue;
  const _Footer({required this.state, required this.onBeforeContinue});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final provider = state.selectedProvider;
    final hasSelection = provider != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.outline)),
      ),
      child: Opacity(
        opacity: hasSelection ? 1 : 0.45,
        child: IgnorePointer(
          ignoring: !hasSelection,
          child: AppButton(
            text: 'Continue',
            onPressed: () {
              onBeforeContinue();
              if (provider == null) return;
              _openInsurance(context, provider);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openInsurance(
    BuildContext context,
    InsuranceProvider provider,
  ) async {
    final mobileResult = await sl<GetAgentMobileUseCase>()();
    final agentMobNo = mobileResult.fold((_) => '', (mobile) => mobile);

    await InsuranceModuleEntry.initialize(
      insuranceProviderData: {
        'vendorCode': provider.vendorCode,
        'vendorKey': provider.vendorKey,
        'vendorMob': provider.vendorMob,
        'agentMobNo': agentMobNo,
        'vendorLogo': provider.vendorLogo.isEmpty
            ? ''
            : sl<AppEnv>().insuranceUri(provider.vendorLogo).toString(),
        'agentCode': agentMobNo,
      },
    );

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => InsuranceModuleEntry.start(
          onExit: () => Navigator.of(routeContext).pop(),
          onSignOut: () => showLogoutDialog(routeContext),
        ),
      ),
    );
  }
}
