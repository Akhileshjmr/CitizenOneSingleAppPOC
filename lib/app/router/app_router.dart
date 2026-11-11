import 'package:citizenone_app/app/router/root_navigator_key.dart';
import 'package:citizenone_app/core/constants/routes_constants.dart';
import 'package:citizenone_app/features/auth/presentation/screens/create_password_screen.dart';
import 'package:citizenone_app/features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'package:citizenone_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:citizenone_app/features/auth/presentation/screens/forgot_password_success_screen.dart';
import 'package:citizenone_app/features/auth/presentation/screens/password_success_screen.dart';
import 'package:citizenone_app/features/auth/presentation/screens/set_password_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_communication_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_document_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_personal_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_professional_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_edit_user_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_history_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_no_record_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_otp_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_preview_submit_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_search_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_submit_status_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_user_details_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:citizenone_app/features/auth/presentation/screens/login_screen.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/app/shell/app_shell.dart';
import 'package:citizenone_app/app/shell/auth_gate.dart';
import 'package:citizenone_app/app/shell/role_resolver.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';

// Role Dashboards
import 'package:citizenone_app/features/customer/dashboard/presentation/screens/super_home_screen.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/screens/agent_dashboard_screen.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/screens/agent_services_dashboard_screen.dart';
import 'package:citizenone_app/features/farmer/dashboard/presentation/screens/farmer_dashboard_screen.dart';

// Common Features
import 'package:citizenone_app/features/common/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:citizenone_app/features/common/notifications/presentation/screens/notifications_screen.dart';
import 'package:citizenone_app/features/common/profile/presentation/screens/profile_screen.dart';
import 'package:citizenone_app/components/shared/service_placeholder_screen.dart';

// Loans
import 'package:citizenone_app/features/common/loans/presentation/screens/loans_dashboard_screen.dart';
import 'package:citizenone_app/features/common/loans/presentation/screens/loan_marketplace_screen.dart';
import 'package:citizenone_app/features/common/loans/presentation/screens/emi_calculator_screen.dart';
import 'package:citizenone_app/features/common/loans/presentation/screens/loan_application_flow_screen.dart';
import 'package:citizenone_app/features/common/loans/presentation/screens/loan_journey_screens.dart';
import 'package:citizenone_app/features/common/loans/presentation/screens/loan_status_tracking_screen.dart';

// Services
import 'package:citizenone_app/features/customer/services/presentation/screens/services_hub_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/banking_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/bill_pay_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/wealth_management_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/insurance_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/health_ezy_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/mobile_recharge_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/sport_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/govt_services_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/marketplace_service_screen.dart';
import 'package:citizenone_app/features/customer/services/presentation/screens/logistics_service_screen.dart';

import 'package:citizenone_app/features/agent/services/presentation/screens/sme_service_screen.dart';
import 'package:citizenone_app/features/agent/tasks/presentation/screens/agent_tasks_screen.dart';
import 'package:citizenone_app/features/agent/customers/presentation/screens/agent_customers_screen.dart';
import 'package:citizenone_app/features/agent/collections/presentation/screens/agent_collections_screen.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/screens/insurance_partner_selection_screen.dart';
import 'package:citizenone_app/features/farmer/services/presentation/screens/agri_service_screen.dart';

import 'package:citizenone_app/features/customer/services/presentation/state/services_cubit.dart'
    as hub;
import 'package:citizenone_app/core/di/di_setup.dart';

import 'package:citizenone_app/features/common/services/presentation/screens/common_services_screen.dart';
import 'package:citizenone_app/features/common/services/presentation/screens/generic_service_screen.dart';

/// Safely extracts a `Map<String, String>` from GoRouter `extra` data.
///
/// `extra` arrives as `Object?` — callers build it with a map literal,
/// and Dart's literal-type inference (e.g. a value sourced from a
/// decoded JSON response, or a field typed `dynamic` upstream) can
/// make its runtime type `Map<String, dynamic>` or similar rather than
/// the exact `Map<String, String>` a blind `as` cast assumes. That
/// mismatch throws a `_TypeError` while building the route. Checking
/// `is Map` and each entry's types instead of casting the whole map
/// tolerates any map shape and simply drops entries that aren't
/// string-to-string, rather than crashing or discarding valid data.
Map<String, String> _stringMapExtra(Object? extra) {
  if (extra is! Map) return const {};
  final result = <String, String>{};
  for (final entry in extra.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key is String && value is String) {
      result[key] = value;
    }
  }
  return result;
}

String _roleBase(BuildContext context) {
  final role = context.read<AuthCubit>().state.selectedRole;
  switch (role) {
    case UserRole.agent:
      return '/agent';
    case UserRole.farmer:
      return '/farmer';
    case UserRole.citizen:
      return '/customer';
  }
}

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(_roleBase(context)),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // --- First-time agent password setup flow ---
    GoRoute(
      path: '/auth/change-password',
      builder: (context, state) {
        final extra = _stringMapExtra(state.extra);
        return SetPasswordScreen(
          mobileNumber: extra['mobileNumber'] ?? '',
          currentPassword: extra['currentPassword'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/auth/password-success',
      builder: (context, state) => const PasswordSuccessScreen(),
    ),

    // --- Forgot password flow (Login → Forgot → OTP → Create → Success) ---
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/auth/forgot-password/otp',
      builder: (context, state) {
        final extra = state.extra;
        final map = extra is Map ? extra : const {};
        String? stringAt(String key) =>
            map[key] is String ? map[key] as String : null;
        int? intAt(String key) => map[key] is int ? map[key] as int : null;
        return ForgotPasswordOtpScreen(
          mobileNumber: stringAt('mobileNumber') ?? '',
          otpExpiresInSeconds: intAt('otpExpiresInSeconds'),
          resendCooldownSeconds: intAt('resendCooldownSeconds'),
          maxAttempts: intAt('maxAttempts'),
          attemptsRemaining: intAt('attemptsRemaining'),
        );
      },
    ),
    GoRoute(
      path: '/auth/create-password',
      builder: (context, state) {
        final extra = _stringMapExtra(state.extra);
        return CreatePasswordScreen(mobileNumber: extra['mobileNumber'] ?? '');
      },
    ),
    GoRoute(
      path: '/auth/forgot-password-success',
      builder: (context, state) => const ForgotPasswordSuccessScreen(),
    ),

    // --- Agent Services Dashboard (full-screen, no bottom-tab shell) ---
    // Post-login landing for the agent role: Insurance / Banking selector.
    GoRoute(
      path: '/agent/dashboard',
      builder: (context, state) => const AgentServicesDashboardScreen(),
    ),

    // --- Insurance Partner Selection (full-screen, no bottom-tab shell) ---
    GoRoute(
      path: '/agent/partners/insurance',
      builder: (context, state) => const InsurancePartnerSelectionScreen(),
    ),

    // --- Legacy Redirects ---
    GoRoute(path: '/home', builder: (context, state) => const RoleResolver()),
    GoRoute(
      path: '/services',
      redirect: (context, state) => '${_roleBase(context)}/services',
    ),
    GoRoute(
      path: '/profile',
      redirect: (context, state) => '${_roleBase(context)}/profile',
    ),
    GoRoute(
      path: '/notifications',
      redirect: (context, state) => '${_roleBase(context)}/notifications',
    ),
    GoRoute(
      path: '/ai-assistant',
      redirect: (context, state) => '${_roleBase(context)}/ai-assistant',
    ),
    GoRoute(
      path: '/services/banking',
      redirect: (context, state) => '/customer/services/banking',
    ),
    GoRoute(
      path: '/services/bills',
      redirect: (context, state) => '/customer/services/bills',
    ),
    GoRoute(
      path: '/services/wallet',
      redirect: (context, state) => '/customer/services/wallet',
    ),
    GoRoute(
      path: '/services/agri',
      redirect: (context, state) => '/farmer/services/agri',
    ),
    GoRoute(
      path: '/services/logistics',
      redirect: (context, state) => '/customer/services/logistics',
    ),
    GoRoute(
      path: '/services/sme',
      redirect: (context, state) => '/agent/services/sme',
    ),
    GoRoute(
      path: '/services/market',
      redirect: (context, state) => '/customer/services/market',
    ),
    GoRoute(
      path: '/services/insurance',
      redirect: (context, state) => '/customer/services/insurance',
    ),
    GoRoute(
      path: '/services/gov',
      redirect: (context, state) => '/customer/services/gov',
    ),
    GoRoute(
      path: '/services/common',
      redirect: (context, state) => '/common/services/common',
    ),
    GoRoute(
      path: '/services/wealth',
      redirect: (context, state) => '/customer/services/wealth',
    ),
    GoRoute(
      path: '/services/health',
      redirect: (context, state) => '/customer/services/health',
    ),
    GoRoute(
      path: '/services/sport',
      redirect: (context, state) => '/customer/services/sport',
    ),
    GoRoute(
      path: '/services/mobile',
      redirect: (context, state) => '/customer/services/mobile',
    ),
    GoRoute(
      path: '/services/loans',
      redirect: (context, state) => '/common/loans',
    ),
    GoRoute(path: '/loans', redirect: (context, state) => '/common/loans'),
    GoRoute(
      path: '/loans/status',
      redirect: (context, state) {
        final ref = state.uri.queryParameters['ref'];
        return '/application/status?ref=${ref ?? ""}';
      },
    ),

    // --- Authenticated App Shell ---
    ShellRoute(
      builder: (context, state, child) {
        return AuthGate(
          child: BlocProvider<hub.ServicesCubit>(
            create: (context) => sl<hub.ServicesCubit>(),
            child: AppShell(child: child),
          ),
        );
      },
      routes: [
        // Role canonical routes
        GoRoute(
          path: '/customer',
          builder: (context, state) => const SuperHomeScreen(),
        ),
        GoRoute(
          path: '/agent',
          builder: (context, state) => const AgentDashboardScreen(),
        ),
        GoRoute(
          path: '/farmer',
          builder: (context, state) => const FarmerDashboardScreen(),
        ),

        // Shared features accessed via canonical roles
        GoRoute(
          path: '/customer/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/agent/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/farmer/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/customer/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/agent/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/farmer/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/customer/ai-assistant',
          builder: (context, state) => const AIAssistantScreen(),
        ),
        GoRoute(
          path: '/agent/ai-assistant',
          builder: (context, state) => const AIAssistantScreen(),
        ),
        GoRoute(
          path: '/farmer/ai-assistant',
          builder: (context, state) => const AIAssistantScreen(),
        ),
        GoRoute(
          path: '/customer/activity',
          builder: (context, state) =>
              const ServicePlaceholderScreen(title: 'Activity'),
        ),
        GoRoute(
          path: '/agent/activity',
          builder: (context, state) =>
              const ServicePlaceholderScreen(title: 'Activity'),
        ),
        GoRoute(
          path: '/farmer/activity',
          builder: (context, state) =>
              const ServicePlaceholderScreen(title: 'Activity'),
        ),

        // Customer Services
        GoRoute(
          path: '/customer/services',
          builder: (context, state) => const ServicesHubScreen(),
        ),
        GoRoute(
          path: '/agent/services',
          redirect: (context, state) => '/agent/services/sme',
        ),
        GoRoute(
          path: '/farmer/services',
          redirect: (context, state) => '/farmer/services/agri',
        ),
        GoRoute(
          path: '/customer/services/bills',
          builder: (context, state) => const BillPayScreen(),
        ),
        GoRoute(
          path: '/customer/services/wallet',
          builder: (context, state) => const GenericServiceScreen(
            title: 'Digital Wallet',
            heroTitle: 'My Wallet',
            heroSubtitle: 'Manage your cards and balance',
            themeColor: AppColors.brandPurple,
          ),
        ),
        GoRoute(
          path: '/customer/services/logistics',
          builder: (context, state) => const LogisticsServiceScreen(),
        ),
        GoRoute(
          path: '/customer/services/market',
          builder: (context, state) => const MarketplaceServiceScreen(),
        ),
        GoRoute(
          path: '/customer/services/insurance',
          builder: (context, state) => const InsuranceScreen(),
        ),
        GoRoute(
          path: '/customer/services/gov',
          builder: (context, state) => const GovtServicesScreen(),
        ),
        GoRoute(
          path: '/customer/services/wealth',
          builder: (context, state) => const WealthManagementScreen(),
        ),
        GoRoute(
          path: '/customer/services/health',
          builder: (context, state) => const HealthEzyScreen(),
        ),
        GoRoute(
          path: '/customer/services/sport',
          builder: (context, state) => const SportScreen(),
        ),
        GoRoute(
          path: '/customer/services/mobile',
          builder: (context, state) => const MobileRechargeScreen(),
        ),
        GoRoute(
          path: '/customer/services/banking',
          builder: (context, state) => const BankingScreen(),
        ),

        // Agent Services
        GoRoute(
          path: '/agent/services/sme',
          builder: (context, state) => const SmeServiceScreen(),
        ),
        GoRoute(
          path: '/agent/services/insurance',
          builder: (context, state) {
            final extra = state.extra;
            return InsuranceScreen(
              provider: extra is InsuranceProvider ? extra : null,
            );
          },
        ),

        // Agent Feature Screens
        GoRoute(
          path: '/agent/tasks',
          builder: (context, state) => const AgentTasksScreen(),
        ),
        GoRoute(
          path: '/agent/customers',
          builder: (context, state) => const AgentCustomersScreen(),
        ),
        GoRoute(
          path: '/agent/collections',
          builder: (context, state) => const AgentCollectionsScreen(),
        ),

        // Farmer Services
        GoRoute(
          path: '/farmer/services/agri',
          builder: (context, state) => const AgriServiceScreen(),
        ),

        // Common Services
        GoRoute(
          path: '/common/services/common',
          builder: (context, state) => const CommonServicesScreen(),
        ),

        // Loans Hub
        GoRoute(
          path: '/common/loans',
          builder: (context, state) => const LoansDashboardScreen(),
          routes: [
            GoRoute(
              path: 'eligibility',
              builder: (context, state) => const LoanEligibilityScreen(),
            ),
            GoRoute(
              path: 'recommendation',
              builder: (context, state) => const AILoanRecommendationScreen(),
            ),
            GoRoute(
              path: 'compare',
              builder: (context, state) => const LoanComparisonScreen(),
            ),
            GoRoute(
              path: 'apply',
              builder: (context, state) => const LoanApplicationScreen(),
            ),
            GoRoute(
              path: 'personal',
              builder: (context, state) =>
                  const LoanMarketplaceScreen(loanType: 'Personal Loan'),
            ),
          ],
        ),
      ],
    ),

    // --- Fullscreen Routes (No Shell) ---
    GoRoute(
      path: '/application/flow',
      builder: (context, state) {
        final loanType =
            state.uri.queryParameters['loanType'] ?? 'Personal Loan';
        final bankName = state.uri.queryParameters['bankName'];
        return LoanApplicationFlowScreen(
          loanType: loanType,
          bankName: bankName,
        );
      },
    ),
    GoRoute(
      path: '/application/status',
      builder: (context, state) {
        final referenceId = state.uri.queryParameters['ref'];
        return LoanStatusTrackingScreen(referenceId: referenceId);
      },
    ),
    GoRoute(
      path: '/tools/emi-calculator',
      builder: (context, state) => const EmiCalculatorScreen(),
    ),

    //KYC
    ShellRoute(
      // navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          BlocProvider(create: (context) => sl<KycBloc>(), child: child),
      routes: [
        GoRoute(
          path: AppRoutes.searchKycUser,
          builder: (context, state) => const KycSearchScreen(),
        ),
        GoRoute(
          path: AppRoutes.noRecordScreen,
          builder: (context, state) => const NoRecordScreen(),
        ),
        GoRoute(
          path: AppRoutes.userDetailScreen,
          builder: (context, state) => const KycDetailsScreen(),
        ),
        GoRoute(
          path: AppRoutes.editUserScreen,
          builder: (context, state) => const EditKycScreen(),
        ),
        GoRoute(
          path: AppRoutes.personalDetailScreen,
          builder: (context, state) => const KycCreatePersonalScreen(),
        ),
        GoRoute(
          path: AppRoutes.professionalDetailScreen,
          builder: (context, state) => const KycCreateProfessionalScreen(),
        ),
        GoRoute(
          path: AppRoutes.communicationDetailScreen,
          builder: (context, state) => const KycCreateCommunicationScreen(),
        ),
        GoRoute(
          path: AppRoutes.documentDetailScreen,
          builder: (context, state) => const KycCreateDocumentScreen(),
        ),
        GoRoute(
          path: AppRoutes.kycHistoryScreen,
          builder: (context, state) => const KycHistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.otpScreen,
          builder: (context, state) => const KycOtpScreen(mobile: ''),
        ),
        GoRoute(
          path: AppRoutes.previewSubmitScreen,
          builder: (context, state) => const KycPreviewSubmitScreen(),
        ),
        GoRoute(
          path: AppRoutes.submitStatusScreen,
          builder: (context, state) => const KycSubmitStatusScreen(),
        ),
      ],
    ),
  ],
);
