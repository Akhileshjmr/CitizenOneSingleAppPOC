import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/design_system/templates/app_desktop_shell.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/active_policy_screen.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/buy_policy_page.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/claim_status_screen.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/due_payment_screen.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/insurance_screen.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/payment_history_screen.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/pages/policy_detail_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/insurance_transaction_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/kyc_no_record_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/motor_insurance_creation_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/motor_insurance_error_page.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/motor_insurance_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/motor_policy_confirmed_page.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/policy_issuance_failed_page.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/transaction_processing_page.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/key_facts_sms_success_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/policy_key_facts_pdf_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/view_details_screen.dart';

import '../../features/motor_insurance/presentation/pages/kyc_user_details_screen.dart';
import '../../features/motor_insurance/presentation/widgets/policy_details_step_widget.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Desktop/tablet-only chrome (permanent sidebar + header). On mobile this
    // is a pure pass-through — `builder` returns `child` unchanged — so
    // mobile rendering/navigation for these routes is unaffected.
    ShellRoute(
      builder: (context, state, child) {
        if (context.isMobile) return child;
        return AppDesktopShell(currentPath: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<InsuranceBloc>(),
            child: const InsuranceScreen(),
          ),
        ),
        ShellRoute(
            builder: (context, state, child) => BlocProvider(
                create: (context) => sl<MotorInsuranceBloc>(), child: child),
            routes: [
              GoRoute(
                path: AppRoutes.motorInsuranceScreen,
                builder: (context, state) => const MotorInsuranceScreen(),
              ),
              // GoRoute(
              //   path: AppRoutes.searchKycUser,
              //   builder: (context, state) {
              //     return const KycSearchScreen();
              //   },
              // ),
              GoRoute(
                path: AppRoutes.noRecordScreen,
                builder: (context, state) {
                  return const NoRecordScreen();
                },
              ),
              GoRoute(
                path: AppRoutes.userDetailScreen,
                builder: (context, state) => const KycManualEntryScreen(),
              ),
              GoRoute(
                path: AppRoutes.motorInsuranceCreationScreen,
                builder: (context, state) =>
                    const MotorInsuranceCreationScreen(),
              ),
              GoRoute(
                path: AppRoutes.policyConfirmedPage,
                builder: (context, state) => const MotorPolicyConfirmedPage(),
              ),
              GoRoute(
                path: AppRoutes.motorInsuranceErrorPage,
                builder: (context, state) => const MotorInsuranceErrorPage(),
              ),
              GoRoute(
                path: AppRoutes.transactionProcessingPage,
                builder: (context, state) => const TransactionProcessingPage(),
              ),
              GoRoute(
                path: AppRoutes.policyIssuanceFailedPage,
                builder: (context, state) => const PolicyIssuanceFailedPage(),
              ),
              GoRoute(
                path: AppRoutes.motorInsurancePage,
                builder: (context, state) =>
                    const MotorInsurancePolicyDetailsScreen(),
              ),
              GoRoute(
                path: AppRoutes.viewPolicyDetailsPage,
                builder: (context, state) => const ViewPolicyDetailsScreen(),
              ),
              GoRoute(
                path: AppRoutes.insuranceTransactionScreen,
                builder: (context, state) => const InsuranceTransactionScreen(),
              ),
              GoRoute(
                path: AppRoutes.policyKeyFactsPdfPage,
                builder: (context, state) {
                  final extra = state.extra;
                  if (extra is PolicyKeyFactsPdfArgs) {
                    return PolicyKeyFactsPdfScreen(
                      pdfUrl: extra.url,
                      pdfBytes: extra.bytes,
                    );
                  }
                  return PolicyKeyFactsPdfScreen(pdfUrl: extra as String?);
                },
              ),
              GoRoute(
                path: AppRoutes.keyFactsSmsSuccessPage,
                builder: (context, state) {
                  final phone = state.extra as String? ?? 'N/A';
                  return KeyFactsSmsSuccessScreen(phoneNumber: phone);
                },
              ),
            ]),
      ],
    ),
    GoRoute(
      path: '/buy-policy',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<InsuranceBloc>(),
        child: const BuyPolicyPage(),
      ),
    ),
    GoRoute(
      path: '/active-policy',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<InsuranceBloc>(),
        child: const MyActivePolicyScreen(),
      ),
    ),
    GoRoute(
      path: '/due-payment',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<InsuranceBloc>(),
        child: const DuePaymentScreen(),
      ),
    ),
    GoRoute(
      path: '/payment-history',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<InsuranceBloc>(),
        child: const PaymentHistoryScreen(),
      ),
    ),
    GoRoute(
      path: '/policy-details',
      builder: (context, state) => const InsuranceDetailsScreen(),
    ),
    GoRoute(
      path: '/claim-status',
      builder: (context, state) => const ClaimStatusScreen(),
    ),
  ],
);
