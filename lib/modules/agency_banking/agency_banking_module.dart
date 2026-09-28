import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'features/dashboard/agency_dashboard_screen.dart';
import 'features/cash_deposit/routes/cash_deposit_routes.dart';

class AgencyBankingModule implements AppModule {
  @override
  String get id => 'agency_banking';

  @override
  String get title => 'Agency Banking';

  @override
  String get initialRoute => '/agency-banking';

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/agency-banking',
          builder: (context, state) => const AgencyDashboardScreen(),
        ),
        GoRoute(
          path: '/agency_banking',
          builder: (context, state) => const AgencyDashboardScreen(),
        ),
        ...cashDepositRoutes,
      ];

  @override
  List<BlocProvider> get providers => [];
}
