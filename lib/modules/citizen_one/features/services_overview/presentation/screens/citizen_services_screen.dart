import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubit/citizen_cubit.dart';
import '../cubit/citizen_state.dart';
import 'package:citizenone_app/modules/citizen_one/theme/citizen_one_colors.dart';

class CitizenServicesScreen extends StatefulWidget {
  const CitizenServicesScreen({super.key});

  @override
  State<CitizenServicesScreen> createState() => _CitizenServicesScreenState();
}

class _CitizenServicesScreenState extends State<CitizenServicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CitizenCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen One Portal'),
        backgroundColor: CitizenOneColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const ModuleSwitcherBar(currentModuleId: 'citizen_one'),
          Expanded(
            child: BlocBuilder<CitizenCubit, CitizenState>(
              builder: (context, state) {
          if (state is CitizenLoading) {
            return const AppLoader(message: 'Loading Citizen Services...');
          }

          if (state is CitizenFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<CitizenCubit>().loadServices(),
            );
          }

          if (state is CitizenLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          CitizenOneColors.primary,
                          CitizenOneColors.secondary
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusLg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, Citizen',
                            style: AppTypography.title
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Unified Government & Civic Services',
                          style: AppTypography.caption
                              .copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Government e-Services', style: AppTypography.title),
                  const SizedBox(height: AppSpacing.md),
                  ...state.services.map(
                    (service) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppCard(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening ${service.title}')),
                          );
                        },
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.account_balance,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(service.title,
                                      style: AppTypography.subtitle),
                                  Text(service.category,
                                      style: AppTypography.caption),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(service.description,
                                      style: AppTypography.body),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ),
  ],
),
    );
  }
}
