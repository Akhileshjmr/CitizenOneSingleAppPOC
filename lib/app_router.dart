import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';

/// Creates the single root GoRouter for CitizenOne App.
/// Accepts the list of active enabled modules generated at build time.
GoRouter createAppRouter(List<AppModule> modules) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => RootHomeScreen(enabledModules: modules),
          ),
          ...modules.expand((module) => module.routes),
        ],
      ),
    ],
    errorBuilder: (context, state) => AppShell(
      location: state.uri.path,
      child: Scaffold(
        body: Center(
          child: AppErrorView(
            title: '404 - Page Not Found',
            message:
                'The path "${state.uri.path}" is not available in the current build configuration.',
            onRetry: () => context.go('/'),
          ),
        ),
      ),
    ),
  );
}

/// Root Landing Dashboard listing active business modules in current build
class RootHomeScreen extends StatelessWidget {
  final List<AppModule> enabledModules;

  const RootHomeScreen({super.key, required this.enabledModules});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return AppCard(
                  color: Colors.blue.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, ${state.user.username}!',
                                  style: AppTypography.subtitle
                                      .copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Email: ${state.user.email} | Roles: ${state.user.roles.join(', ')}',
                                  style: AppTypography.caption,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppButton(
                            label: 'Sign Out',
                            size: AppButtonSize.small,
                            variant: AppButtonVariant.outlined,
                            onPressed: () => context.read<AuthCubit>().logout(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return AppCard(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.lock_outline, color: Colors.white),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guest Session Active',
                            style: AppTypography.subtitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Sign in to access personalized services.',
                            style: AppTypography.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: 'Sign In',
                      size: AppButtonSize.small,
                      onPressed: () => context.push('/login'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  radius: 24,
                  child: Icon(
                    Icons.layers_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CitizenOne SuperApp Hub',
                        style: AppTypography.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${enabledModules.length} Active Business Modules Enabled',
                        style: AppTypography.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Business Modules',
                  style: AppTypography.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Chip(
                label: Text('${enabledModules.length} Available'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (enabledModules.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No business modules enabled in build/modules.yaml'),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: enabledModules.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final module = enabledModules[index];
                final routePath = module.initialRoute;
                final moduleColor = AppTheme.moduleBrandColors[module.id] ??
                    Theme.of(context).colorScheme.primary;

                return AppCard(
                  onTap: () => context.go(routePath),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: moduleColor,
                      child: Text(
                        module.title.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      module.title,
                      style: AppTypography.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'ID: ${module.id} | Route: $routePath',
                      style: AppTypography.caption,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: moduleColor,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
