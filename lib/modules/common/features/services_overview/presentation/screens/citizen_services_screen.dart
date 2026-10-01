import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubit/citizen_cubit.dart';
import '../cubit/citizen_state.dart';

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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<CitizenCubit, CitizenState>(
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
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Common Citizen Services',
                        style: AppTypography.title.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Unified portal for government & civic services',
                        style: AppTypography.caption.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('Government e-Services', style: AppTypography.title),
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
                          CircleAvatar(
                            backgroundColor: primaryColor.withValues(alpha: 0.15),
                            child: Icon(Icons.account_balance, color: primaryColor),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.title, style: AppTypography.subtitle),
                                Text(service.category, style: AppTypography.caption),
                                const SizedBox(height: AppSpacing.xs),
                                Text(service.description, style: AppTypography.body),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
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
    );
  }
}
